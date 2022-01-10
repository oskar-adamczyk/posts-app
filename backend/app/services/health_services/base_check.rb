# frozen_string_literal: true

module HealthServices
  class BaseCheck < BaseService
    class Result < BaseServiceResult
      attribute :health, Strict::Any.constrained(type: Virtual::Health)

      delegate :healthy?, to: :health
    end

    private

    def perform
      Result.new health: health
    end

    def health
      @health ||= Virtual::Health.new id: Time.zone.now, status: status
    end

    # :nocov:
    def status
      raise NotImplementedError
    end
    # :nocov:
  end
end
