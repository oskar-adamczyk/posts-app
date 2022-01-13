# frozen_string_literal: true

require "spec_helper"

RSpec.describe "API V1 origin ips index", type: :request do
  describe "/origin_ips" do
    context "lists origin ips for given parameters" do
      let(:url) { "/api/v1/origin_ips" }

      context "with valid sorting parameter" do
        let!(:origin_ips) do
          [
            create(:origin_ip, authors: 2.times.map { Faker::Internet.email }),
            create(:origin_ip)
          ]
        end
        let(:params) { { page: { number: 1, size: 2 } } }
        before do
          expect_schema_validation_for fragment: "#/responses/origin_ips_index", namespace: %w[api v1]
          json_api_get(params: params)
        end

        it "list origin ips and returns properly sorted resources" do
          expect(last_response.status).to eq 200
          expect(json_response["data"])
            .to include(
              {
                "attributes" => {
                  "address" => origin_ips.first.address,
                  "authors" => origin_ips.first.authors
                },
                "id" => origin_ips.first.id,
                "type" => "origin_ips"
              },
              {
                "attributes" => {
                  "address" => origin_ips.second.address,
                  "authors" => origin_ips.second.authors
                },
                "id" => origin_ips.second.id,
                "type" => "origin_ips"
              }
            )
          expect(json_response["links"])
            .to eq(
              {
                "first" => "http://example.org/api/v1/origin_ips?page%5Bnumber%5D=1&page%5Bsize%5D=2",
                "last" => "http://example.org/api/v1/origin_ips?page%5Bnumber%5D=1&page%5Bsize%5D=2",
                "next" => nil,
                "prev" => nil,
                "self" => "http://example.org/api/v1/origin_ips?page%5Bnumber%5D=1&page%5Bsize%5D=2"
              }
            )
        end
      end

      context "with invalid pagination" do
        before { json_api_get(params: params) }

        let(:params) { { page: { number: 1, size: 0 } } }

        it { expect(last_response.status).to eq 400 }
      end
    end
  end
end
