# frozen_string_literal: true

class Router
  class Error < StandardError; end

  CONTROLLER_ACTIONS = {
    ["GET", true] => :show,
    ["GET", false] => :index,
    ["POST", true] => :create,
    ["POST", false] => :create
  }.freeze
  ROUTES = YAML.load_file("config/routing.yml")

  def self.route(method:, path:)
    path_parts = path.split("/").reject(&:empty?)
    controller_parts, params = resolve_controller path_parts
    action = CONTROLLER_ACTIONS.fetch(
      [
        method,
        controller_parts.last.singular? || params.fetch("#{controller_parts.last.singularize}_id".to_sym, nil).present?
      ]
    )
    validate_routes!(action, controller_parts.dup)
    [action, "#{controller_parts.map(&:capitalize).join('::')}Controller".constantize, params]
  end

  def self.resolve_actions(controller_parts, routes = ROUTES)
    head = controller_parts.shift
    deep_routes = routes[head]
    return deep_routes if controller_parts.empty?
    return resolve_actions(controller_parts, deep_routes) if deep_routes.is_a? Hash

    routes = deep_routes.find { |deep_route| deep_route.is_a? Hash }
    resolve_actions(controller_parts, routes)
  end

  def self.resolve_controller(path_parts)
    params = {}
    head = path_parts.shift

    return [[], params] unless head

    controller_parts = [head]
    params["#{head.singularize}_id".to_sym] = path_parts.shift if head.plural?
    deep_controller_parts, deep_params = resolve_controller path_parts

    params.merge!(deep_params)
    controller_parts += deep_controller_parts

    [controller_parts, params]
  end

  def self.validate_routes!(action, controller_parts)
    actions = resolve_actions(controller_parts)
    raise Error, "Route is not defined" unless actions.is_a?(Array) && actions.include?(action.to_s)
  rescue StandardError
    raise Error, "Route is not defined"
  end

  private_class_method :resolve_actions, :resolve_controller, :validate_routes!
end
