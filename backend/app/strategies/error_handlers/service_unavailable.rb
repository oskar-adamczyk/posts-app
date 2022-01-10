# frozen_string_literal: true

module ErrorHandlers
  class ServiceUnavailable < Base
    register_self Errors::ServiceUnavailable

    private

    def perform
      Result.new content: Hash.new(:nothing), options: { status: :service_unavailable }
    end
  end
end
