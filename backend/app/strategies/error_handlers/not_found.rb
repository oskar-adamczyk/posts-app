# frozen_string_literal: true

module ErrorHandlers
  class NotFound < Base
    register_self Errors::NotFound

    private

    def perform
      Result.new content: Hash.new(:nothing), options: { status: :not_found }
    end
  end
end
