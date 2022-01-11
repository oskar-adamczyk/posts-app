# frozen_string_literal: true

module Api
  module V1
    class OriginIpsController < BaseController
      include Concerns::Paginator

      def index
        json res: origin_ips, serializer: OriginIpSerializer, status: :ok, serialization_opts: { collection?: true }
      end

      private

      def origin_ips
        @origin_ips ||= OriginIpServices::Fetch.call(conditions: {}, pagination: pagination).origin_ips
      end
    end
  end
end
