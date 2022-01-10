# frozen_string_literal: true

class BaseFind < BaseService
  def initialize(**params)
    super(**params)
    raise ArgumentError "Invalid conditions type" unless conditions_valid?

    @conditions = params.fetch :conditions
  end

  private

  attr_reader :conditions, :resource

  def conditions_valid?
    params.fetch(:conditions).is_a?(Hash) || params.fetch(:conditions).is_a?(Arel::Nodes::Node)
  end

  def perform
    ApplicationRecord.transaction do
      find!

      result
    end
  end

  def find!
    @resource = scope.find_by! conditions
  rescue ActiveRecord::RecordNotFound
    raise Errors::NotFound
  end

  # :nocov:
  def result
    raise NotImplementedError
  end
  # :nocov:

  # :nocov:
  def scope
    raise NotImplementedError
  end
  # :nocov:
end
