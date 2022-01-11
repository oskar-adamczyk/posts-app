# frozen_string_literal: true

module Api
  module V1
    class PostsController < BaseController
      include Concerns::Paginator

      def create
        json res: created_post, serializer: PostSerializer, status: :created
      end

      def index
        json res: posts, serializer: ListedPostSerializer, status: :ok, serialization_opts: { collection?: true }
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

      def posts
        @posts ||= PostServices::Fetch.call(conditions: {}, pagination: pagination).posts
      end
    end
  end
end
