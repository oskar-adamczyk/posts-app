# frozen_string_literal: true

require "spec_helper"

RSpec.describe "API V1 posts ratings create", type: :request do
  describe "/posts/:post_id/ratings" do
    context "creates ratings for post with given rate" do
      let(:url) { "/api/v1/posts/#{post_id}/ratings" }
      let(:post_id) { existing_post.id }
      let(:existing_post) { create(:post, ratings: past_ratings) }
      let(:past_ratings) { create_list(:rating, 1, rate: 2) }
      let(:params) do
        {
          data: {
            attributes: {
              rate: 1
            },
            type: "ratings"
          }
        }
      end
      let(:created_rating) { Rating.order(created_at: :desc).first }

      context "with valid attributes" do
        before do
          expect_schema_validation_for fragment: "#/requests/posts_ratings_create", namespace: %w[api v1]
          expect_schema_validation_for fragment: "#/responses/posts_ratings_create", namespace: %w[api v1]
          json_api_post
        end

        it "creates rating and returns created resource with attached post and average rating" do
          expect(last_response.status).to eq 201
          expect(json_response["data"])
            .to eq(
              {
                "attributes" => {
                  "rate" => 1
                },
                "id" => created_rating.id,
                "relationships" => {
                  "post" => {
                    "data" => {
                      "id" => post_id,
                      "type" => "posts"
                    }
                  }
                },
                "type" => "ratings"
              }
            )
          expect(json_included_ids).to include post_id
          expect(json_included_attrs("posts"))
            .to eq([{ "average_rate" => 1.5 }])
        end
      end

      context "with invalid attributes" do
        context "with invalid params" do
          before { json_api_post }

          let(:params) { {} }

          it { expect(last_response.status).to eq 400 }
        end

        context "with not existing post" do
          before { json_api_post }

          let(:post_id) { SecureRandom.uuid }

          it { expect(last_response.status).to eq 404 }
        end
      end
    end
  end
end
