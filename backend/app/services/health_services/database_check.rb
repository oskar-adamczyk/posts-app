# frozen_string_literal: true

module HealthServices
  class DatabaseCheck < BaseCheck
    private

    def status
      return :failing unless ActiveRecord::Base.connection.active?

      :healthy
    end
  end
end
