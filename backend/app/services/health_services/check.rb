# frozen_string_literal: true

module HealthServices
  class Check < BaseCheck
    private

    def status
      raise Errors::ServiceUnavailable unless health_checks.map(&:call).all?(&:healthy?)

      :healthy
    end

    def health_checks
      PostsApp.config.health_checks.map(&:constantize)
    end
  end
end
