# frozen_string_literal: true

module Api
  module V1
    class PostsController < BaseController
      def create
        json res: created_post, serializer: PostSerializer, status: :created
      end

      private

      def created_post
        @created_post ||= PostServices::Create.call(attributes: { **post_params }).post
      end

      def post_params
        @post_params ||= ActiveModelSerializers::Deserialization.jsonapi_parse!(
          params.deep_stringify_keys, only: %i[content origin_ip title user_email]
        )
      end
    end
  end
end
