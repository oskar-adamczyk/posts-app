# frozen_string_literal: true

module Api
  module Concerns
    module Paginator
      extend ActiveSupport::Concern

      private

      def pagination
        return Pagination.new page: nil, per_page: nil if params[:page].blank?

        Pagination.new(page: params[:page][:number], per_page: params[:page][:size])
      rescue Dry::Struct::Error
        raise Errors::BadRequest
      end
    end
  end
end
