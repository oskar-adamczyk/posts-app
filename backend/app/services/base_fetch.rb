# frozen_string_literal: true

class BaseFetch < BaseService
  def initialize(**params)
    super(**params)
    raise ArgumentError, "Invalid conditions type" unless conditions_valid?
    raise ArgumentError, "Invalid pagination type" unless pagination_valid?

    @conditions = params.fetch :conditions
    @pagination = params.fetch :pagination
  end

  private

  attr_reader :conditions, :pagination, :resources

  def conditions_valid?
    params.fetch(:conditions).is_a?(Hash) || params.fetch(:conditions).is_a?(Arel::Nodes::Node)
  end

  def pagination_valid?
    params.fetch(:pagination).is_a? Pagination
  end

  def perform
    fetch

    result
  end

  def fetch
    @resources = scope.where(conditions).page(pagination.page).per pagination.per_page
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
