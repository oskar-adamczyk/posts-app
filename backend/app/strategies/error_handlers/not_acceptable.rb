# frozen_string_literal: true

module ErrorHandlers
  class NotAcceptable < Base
    register_self Errors::NotAcceptable

    private

    def perform
      Result.new content: Hash.new(:nothing), options: { status: :not_acceptable }
    end
  end
end
