# frozen_string_literal: true

require "spec_helper"

RSpec.describe "API V1 health show", type: :request do
  describe "/health" do
    context "receives service health status" do
      let(:url) { "/api/v1/health" }
      let(:now) { Time.zone.now }

      context "when service and his dependencies are healthy" do
        before do
          expect_schema_validation_for fragment: "#/responses/health_show", namespace: %w[api v1]
          json_api_get
        end

        it "checks and returns health status" do
          expect(last_response.status).to eq 200
          expect(json_response["data"])
            .to eq(
              {
                "attributes" => {
                  "status" => "healthy"
                },
                "id" => now.iso8601,
                "type" => "healths"
              }
            )
        end
      end

      context "when service or any of his dependencies is failing" do
        before do
          allow_any_instance_of(HealthServices::DatabaseCheck).to receive(:call).and_return(
            HealthServices::Check::Result.new(health: Virtual::Health.new(id: now, status: :failing))
          )
          json_api_get
        end

        it { expect(last_response.status).to eq 503 }
      end
    end
  end
end
