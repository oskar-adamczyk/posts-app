# frozen_string_literal: true

module ErrorHandlers
  class BadRequest < Base
    register_self Errors::BadRequest

    private

    def perform
      Result.new content: Hash.new(:nothing), options: { status: :bad_request }
    end
  end
end
