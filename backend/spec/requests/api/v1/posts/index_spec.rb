# frozen_string_literal: true

require "spec_helper"

RSpec.describe "API V1 posts index", type: :request do
  describe "/posts" do
    context "lists posts for given parameters" do
      let(:url) { "/api/v1/posts" }
      let!(:posts) do
        {
          "2.5" => create(:post, average_rate: 2.5, content: "example content", title: "example title rate 2.5"),
          "1.5" => create(:post, average_rate: 1.5, content: "example content", title: "example title rate 1.5"),
          "4.5" => create(:post, average_rate: 4.5, content: "example content", title: "example title rate 4.5")
        }
      end

      context "with valid sorting parameter" do
        let(:params) { { page: { number: 1, size: 2 } } }
        before do
          expect_schema_validation_for fragment: "#/responses/posts_index", namespace: %w[api v1]
          json_api_get(params: params)
        end

        it "list posts and returns properly sorted resources" do
          expect(last_response.status).to eq 200
          expect(json_response["data"])
            .to eq(
              [
                {
                  "attributes" => {
                    "content" => "example content",
                    "title" => "example title rate 4.5"
                  },
                  "id" => posts["4.5"].id,
                  "type" => "posts"
                },
                {
                  "attributes" => {
                    "content" => "example content",
                    "title" => "example title rate 2.5"
                  },
                  "id" => posts["2.5"].id,
                  "type" => "posts"
                }
              ]
            )
          expect(json_response["links"])
            .to eq(
              {
                "first" => "http://example.org/api/v1/posts?"\
                           "page%5Bnumber%5D=1&page%5Bsize%5D=2&page%5Bnumber%5D=1&page%5Bsize%5D=2",
                "last" => "http://example.org/api/v1/posts?"\
                          "page%5Bnumber%5D=1&page%5Bsize%5D=2&page%5Bnumber%5D=2&page%5Bsize%5D=2",
                "next" => "http://example.org/api/v1/posts?"\
                          "page%5Bnumber%5D=1&page%5Bsize%5D=2&page%5Bnumber%5D=2&page%5Bsize%5D=2",
                "prev" => nil,
                "self" => "http://example.org/api/v1/posts?"\
                          "page%5Bnumber%5D=1&page%5Bsize%5D=2&page%5Bnumber%5D=1&page%5Bsize%5D=2"
              }
            )
        end
      end
    end
  end
end
