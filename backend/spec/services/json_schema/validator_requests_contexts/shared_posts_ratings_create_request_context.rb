# frozen_string_literal: true

RSpec.shared_context "validating posts ratings create request", shared_context: :metadata do
  context "validating posts ratings create request" do
    let(:valid_attrs) { { rate: 1 } }
    let(:attributes) { valid_attrs }
    let(:type) { "ratings" }
    let(:fragment) { "#/requests/posts_ratings_create" }
    let(:namespace) { %w[api v1] }

    context "with valid attributes" do
      it { expect { subject }.not_to raise_error }
    end

    [
      [{ data: { attributes: { rate: "1" } } }, "string rate"],
      [{ data: { attributes: { rate: 0 } } }, "rate lower than 1"],
      [{ data: { attributes: { rate: 6 } } }, "rate greater than 5"],
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
      let(:type) { "rating" }

      it { expect { subject }.to raise_error Errors::BadRequest }
    end
  end
end
