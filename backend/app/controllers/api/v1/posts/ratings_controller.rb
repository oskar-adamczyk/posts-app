# frozen_string_literal: true

module Api
  module V1
    module Posts
      class RatingsController < BaseController
        def create
          json res: created_rating, serializer: RatingSerializer, status: :created, include: :post
        end

        private

        def created_rating
          @created_rating ||= RatingServices::RatePost.call(attributes: { **rating_params }, max_retries: 5).rating
        end

        def rating_params
          @rating_params ||= ActiveModelSerializers::Deserialization.jsonapi_parse!(
            params.deep_stringify_keys, only: %i[post_id rate]
          ).merge(post_id: params.fetch(:post_id))
        end
      end
    end
  end
end
