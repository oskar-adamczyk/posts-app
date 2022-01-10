# frozen_string_literal: true

module Api
  module V1
    class BaseController < AbstractController
      private

      def schema_namespace
        super << :v1
      end
    end
  end
end
