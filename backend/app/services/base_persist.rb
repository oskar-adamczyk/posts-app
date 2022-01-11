# frozen_string_literal: true

class BasePersist < BaseService
  define_callbacks :assign_attributes
  define_callbacks :save_resource

  def initialize(**params)
    super(**params)
    raise ArgumentError "Invalid attributes type" unless attributes_valid?

    @attributes = params.fetch :attributes
  end

  private

  attr_reader :attributes

  def attributes_valid?
    params.fetch(:attributes).is_a? Hash
  end

  def perform
    ApplicationRecord.transaction(isolation: isolation) do
      run_callbacks :assign_attributes do
        resource.assign_attributes attributes
      end

      validate_resource!

      run_callbacks :save_resource do
        resource.save!
      end

      result
    end
  end

  def isolation
    :read_committed
  end

  # :nocov:
  def resource
    raise NotImplementedError
  end
  # :nocov:

  # :nocov:
  def result
    raise NotImplementedError
  end
  # :nocov:

  def validate_resource!
    return if resource.valid?

    raise Errors::UnprocessableEntity.new entity: resource
  end
end
