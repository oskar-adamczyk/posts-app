# frozen_string_literal: true

module ErrorHandlers
  class Unauthorized < Base
    register_self Errors::Unauthorized

    private

    def perform
      Result.new content: Hash.new(:nothing), options: { status: :unauthorized }
    end
  end
end
