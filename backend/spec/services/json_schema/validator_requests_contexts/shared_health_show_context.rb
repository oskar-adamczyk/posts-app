# frozen_string_literal: true

RSpec.shared_context "validating health show", shared_context: :metadata do
  context "validating health show" do
    let(:valid_attrs) { { status: "healthy" } }
    let(:attributes) { valid_attrs }
    let(:type) { "healths" }
    let(:fragment) { "#/responses/health_show" }
    let(:namespace) { %w[api v1] }

    context "with valid attributes" do
      it { expect { subject }.not_to raise_error }
    end

    [
      [{ data: { attributes: { status: "unexpected" } } }, "unexpected status"],
      [{ data: { attributes: {} } }, "with missing status"],
      [{ data: {} }, "missing attributes object"],
      [{}, "missing data object"]
    ].each do |attributes, description|
      context "with #{description}" do
        let(:body) { attributes }

        it { expect { subject }.to raise_error Errors::BadRequest }
      end
    end

    context "with invalid, singular type" do
      let(:type) { "health" }

      it { expect { subject }.to raise_error Errors::BadRequest }
    end
  end
end
