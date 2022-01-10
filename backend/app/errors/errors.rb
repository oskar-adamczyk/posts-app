# frozen_string_literal: true

module Errors
  class BadRequest < StandardError; end

  class NotAcceptable < StandardError; end

  class NotFound < StandardError; end

  class ServiceUnavailable < StandardError; end

  class Unauthorized < StandardError; end

  class UnprocessableEntity < StandardError
    def initialize(entity:)
      raise ArgumentError, "Entity does not contain errors" if entity.errors.empty?

      @entity = entity
      super
    end

    attr_reader :entity
  end

  class UnsupportedMediaType < StandardError; end
end
