# frozen_string_literal: true

module ErrorHandlers
  class UnprocessableEntity < Base
    register_self Errors::UnprocessableEntity

    private

    def perform
      Result.new content: { json: error.entity }, options: {
        serializer: ActiveModel::Serializer::ErrorSerializer,
        status: :unprocessable_entity
      }
    end
  end
end
