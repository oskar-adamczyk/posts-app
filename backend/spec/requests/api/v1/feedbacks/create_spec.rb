# frozen_string_literal: true

require "spec_helper"

RSpec.describe "API V1 feedbacks create", type: :request do
  describe "/feedbacks" do
    context "creates feedback with given attributes" do
      let!(:existing_feedback) { create :feedback, :for_post, owner: owner }
      let(:url) { "/api/v1/feedbacks" }
      let(:owner) { create :user }
      let(:params) do
        {
          data: {
            attributes: {
              comment: "example comment",
              owner_id: owner.id,
              user_id: owner.id
            },
            type: "feedbacks"
          }
        }
      end
      let(:created_feedback) { Feedback.order(created_at: :desc).first }

      context "with valid attributes" do
        before do
          expect_schema_validation_for fragment: "#/requests/feedbacks_create", namespace: %w[api v1]
          expect_schema_validation_for fragment: "#/responses/feedbacks_create", namespace: %w[api v1]
          json_api_post
        end

        it "creates feedback and returns created resource", type: :transactional do
          expect(last_response.status).to eq 201
          expect(json_response["data"])
            .to include(
              {
                "attributes" => {
                  "comment" => "example comment"
                },
                "id" => created_feedback.id,
                "relationships" => {
                  "owner" => {
                    "data" => {
                      "id" => owner.id,
                      "type" => "users"
                    }
                  },
                  "post" => {
                    "data" => nil
                  },
                  "user" => {
                    "data" => {
                      "id" => owner.id,
                      "type" => "users"
                    }
                  }
                },
                "type" => "feedbacks"
              },
              {
                "attributes" => {
                  "comment" => existing_feedback.comment
                },
                "id" => existing_feedback.id,
                "relationships" => {
                  "owner" => {
                    "data" => {
                      "id" => owner.id,
                      "type" => "users"
                    }
                  },
                  "post" => {
                    "data" => {
                      "id" => existing_feedback.commentable_id,
                      "type" => "posts"
                    }
                  },
                  "user" => {
                    "data" => nil
                  }
                },
                "type" => "feedbacks"
              }
            )
        end
      end

      context "with invalid attributes" do
        context "with invalid params" do
          before { json_api_post }

          let(:params) { {} }

          it { expect(last_response.status).to eq 400 }
        end

        context "with already taken title", type: :transactional do
          let!(:existing_feedback) { create :feedback, commentable: owner, owner: owner }
          before { json_api_post }

          it { expect(last_response.status).to eq 422 }
        end
      end
    end
  end
end
