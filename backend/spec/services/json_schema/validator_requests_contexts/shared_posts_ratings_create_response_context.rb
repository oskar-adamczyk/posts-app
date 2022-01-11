# frozen_string_literal: true

RSpec.shared_context "validating posts ratings create response", shared_context: :metadata do
  context "validating posts ratings create response" do
    let(:valid_attrs) { { rate: rate } }
    let(:rate) { 1 }
    let(:attributes) { valid_attrs }
    let(:type) { "ratings" }
    let(:fragment) { "#/responses/posts_ratings_create" }
    let(:namespace) { %w[api v1] }
    let(:body) { { data: data, included: included } }
    let(:data) do
      {
        attributes: attributes,
        id: SecureRandom.uuid,
        relationships: relationships,
        type: type
      }
    end
    let(:included) { [included_post] }
    let(:included_post) do
      {
        id: SecureRandom.uuid,
        type: "posts",
        attributes: {
          average_rate: average_rate
        }
      }
    end
    let(:average_rate) { 1.2 }
    let(:relationships) do
      {
        post: {
          data: {
            id: SecureRandom.uuid,
            type: "posts"
          }
        }
      }
    end

    context "with valid attributes" do
      it { expect { subject }.not_to raise_error }
    end
    [["1.2", "string average rate"],
     [-0.1, "average rate lower than 0"],
     [5.1, "average rate greater than 5"]].each do |average_rate, description|
      context "with #{description}" do
        let(:average_rate) { average_rate }

        it { expect { subject }.to raise_error Errors::BadRequest }
      end
    end

    [["1.2", "string rate"],
     [0.9, "rate lower than 1"],
     [5.1, "rate greater than 5"]].each do |rate, description|
      context "with #{description}" do
        let(:rate) { rate }

        it { expect { subject }.to raise_error Errors::BadRequest }
      end
    end

    [[2, "too included many"],
     [0, "empty included array"]].each do |included_count, description|
      context "with #{description}" do
        let(:included) { included_count.times.map { included_post } }

        it { expect { subject }.to raise_error Errors::BadRequest }
      end
    end

    context "with invalid, singular type" do
      let(:type) { "rating" }

      it { expect { subject }.to raise_error Errors::BadRequest }
    end
  end
end
