# frozen_string_literal: true

require "spec_helper"

RSpec.describe "API V1 posts create", type: :request do
  describe "/posts" do
    context "creates post with given attributes" do
      let(:url) { "/api/v1/posts" }
      let(:title) { "example title" }
      let(:params) do
        {
          data: {
            attributes: {
              content: "example content",
              origin_ip: "127.0.0.1",
              title: title,
              user_email: "test@example.com"
            },
            type: "posts"
          }
        }
      end
      let(:created_post) { Post.order(created_at: :desc).first }

      context "with valid attributes" do
        before do
          expect_schema_validation_for fragment: "#/requests/posts_create", namespace: %w[api v1]
          expect_schema_validation_for fragment: "#/responses/posts_create", namespace: %w[api v1]
          json_api_post
        end

        it "creates post and returns created resource" do
          expect(last_response.status).to eq 201
          expect(json_response["data"])
            .to eq(
              {
                "attributes" => {
                  "content" => "example content",
                  "origin_ip" => "127.0.0.1",
                  "title" => "example title"
                },
                "id" => created_post.id,
                "type" => "posts"
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
          before { json_api_post }

          it { expect(last_response.status).to eq 422 }
        end
      end
    end
  end
end
