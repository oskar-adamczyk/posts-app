# frozen_string_literal: true

module JsonSchemaServices
  class Validate < BaseService
    class Result < BaseServiceResult; end

    private

    def perform
      Result.new.tap do
        next if errors.empty?

        # TODO: better log and monitor error
        pp errors unless PostsApp.test?
        raise Errors::BadRequest
      end
    end

    def errors
      @errors ||= JSON::Validator.fully_validate(
        params.fetch(:schema), params.fetch(:body), fragment: params.fetch(:fragment)
      )
    rescue JSON::Schema::ValidationError, JSON::Schema::SchemaError => e
      # TODO: better log and monitor error
      pp [e.message]
      raise Errors::BadRequest
    end
  end
end
