# frozen_string_literal: true

module Api
  module V1
    class HealthController < BaseController
      def show
        json res: health, serializer: HealthSerializer, status: :ok
      end

      private

      def health
        @health ||= HealthServices::Check.call.health
      end
    end
  end
end
