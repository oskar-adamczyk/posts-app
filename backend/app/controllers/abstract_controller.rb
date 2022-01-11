# frozen_string_literal: true

class AbstractController
  include ActiveSupport::Callbacks

  define_callbacks :call
  set_callback :call, :before, :validate_request_headers!, :validate_request_body!
  set_callback :call, :after, :validate_response_body!

  JSON_API_HEADER = "application/vnd.api+json"

  def initialize(action:, params:, request:, response:)
    @action = action
    request.body.rewind
    @body_params_json = request.body.read
    @body_params_json = "{}" if @body_params_json.empty?
    @params = params.merge(JSON.parse(body_params_json, symbolize_names: true))
    @request = request
    @response = response
  end

  def call
    run_callbacks :call do
      send action
    end
  rescue StandardError => e
    handle e
  end

  def self.call(action:, params:, request:, response:)
    new(action: action, params: params, request: request, response: response).call
  end

  private

  attr_reader :action, :body_params_json, :params, :request, :response

  def handle(error)
    ErrorHandlers.strategy(error.class).call(error: error).tap do |res|
      json(res: res.content.fetch(:json, {}), serializer: res.options.serializer, status: res.options.status)
    end
  rescue KeyError
    # TODO: better log and monitor error
    pp error, error.backtrace unless PostsApp.production?
    render_internal_server_error
  end

  def json(res:, serializer:, status:, headers: {}, serialization_opts: {})
    response.status = Rack::Utils.status_code status
    body = serialize_response(res, serialization_opts, serializer)
    response.body = [body.to_json]
    response.set_header "Content-Type", JSON_API_HEADER
    headers.each_with_index { |header_value, header_key| response.set_header header_key, header_value }
  end

  def serialize_response(res, serialization_opts, serializer)
    ActiveModelSerializers::SerializableResource.new(
      res,
      serializer: serialization_opts[:collection?] ? ActiveModel::Serializer::CollectionSerializer : serializer,
      each_serializer: serializer,
      include: serialization_opts[:include],
      serialization_context: ActiveModelSerializers::SerializationContext.new(
        request_url: request.url[/\A[^?]+/],
        query_parameters: request.params
      )
    ).as_json
  end

  def render_internal_server_error
    response.status = Rack::Utils.status_code :internal_server_error
    response.body = {}
  end

  def schema_namespace
    %i[api]
  end

  def validate_request_body!
    return if %w[GET DELETE].include? request.request_method

    JsonSchemaServices::Validate.call(
      body: body_params_json, fragment: "#/requests/#{request_name}", schema: schema
    )
  end

  def validate_request_headers!
    raise Errors::NotAcceptable if
      request.get_header("HTTP_ACCEPT") != JSON_API_HEADER && request.get_header("Accept") != JSON_API_HEADER
    return if request.get? || request.delete?
    raise Errors::UnsupportedMediaType if
      request.get_header("CONTENT_TYPE") != JSON_API_HEADER &&
      request.get_header("Content-Type") != JSON_API_HEADER
  end

  def validate_response_body!
    return if PostsApp.production? || %w[DELETE].include?(request.request_method)

    JsonSchemaServices::Validate.call(body: response.body.first, fragment: "#/responses/#{request_name}",
                                      schema: schema)
  rescue Errors::BadRequest
    render_internal_server_error
  end

  def request_name
    (
      (self.class.to_s.split("::")[schema_namespace.size..] || [])
        .map { |controller| controller.gsub "Controller", "" }
        .map(&:underscore) << action
    ).join("_")
  end

  def schema
    JsonSchemaServices::Read.call(namespace: schema_namespace).schema
  end
end
