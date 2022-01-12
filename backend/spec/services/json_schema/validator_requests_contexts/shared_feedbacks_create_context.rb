# frozen_string_literal: true

require_relative "./shared_json_api_context"

RSpec.shared_context "validating feedbacks create", shared_context: :metadata do
  context "validating feedbacks create" do
    let(:attributes) { valid_attrs }
    let(:attributes) { valid_attrs }
    let(:type) { "feedbacks" }
    let(:namespace) { %w[api v1] }

    let(:valid_attrs) do
      {
        comment: comment,
        owner_id: SecureRandom.uuid,
        user_id: SecureRandom.uuid
      }
    end
    let(:comment) { "test comment" }
    let(:fragment) { "#/requests/feedbacks_create" }

    context "with feedback for post instead of user" do
      let(:valid_attrs) do
        {
          comment: comment,
          owner_id: SecureRandom.uuid,
          post_id: SecureRandom.uuid
        }
      end

      it { expect { subject }.not_to raise_error }
    end

    [
      ["a", "too short comment"],
      [257.times.map { "a" }.join, "too long comment"]
    ].each do |comment, description|
      context "with #{description}" do
        let(:comment) { comment }

        it { expect { subject }.to raise_error Errors::BadRequest }
      end
    end

    context "with invalid, singular type" do
      let(:type) { "feedback" }

      it { expect { subject }.to raise_error Errors::BadRequest }
    end

    include_context "validating base json api body context"
  end
end
