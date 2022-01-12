# frozen_string_literal: true

module Api
  module V1
    class FeedbacksController < BaseController
      def create
        json res: owner_feedbacks,
             serializer: FeedbackSerializer,
             status: :created,
             serialization_opts: { collection?: true }
      end

      private

      def owner_feedbacks
        @owner_feedbacks ||= FeedbackServices::Create.call(attributes: { **feedback_params }).owner_feedbacks
      end

      def feedback_params
        @feedback_params ||= ActiveModelSerializers::Deserialization.jsonapi_parse!(
          params.deep_stringify_keys, only: %i[comment owner_id post_id user_id]
        )
      end
    end
  end
end
