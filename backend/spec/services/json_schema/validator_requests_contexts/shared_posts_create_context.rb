# frozen_string_literal: true

RSpec.shared_context "validating posts create", shared_context: :metadata do
  context "validating posts create" do
    let(:attributes) { valid_attrs }
    let(:attributes) { valid_attrs }
    let(:type) { "posts" }
    let(:namespace) { %w[api v1] }

    let(:valid_attrs) do
      {
        content: "test content",
        origin_ip: "127.0.0.1",
        title: "test title",
        user_email: "test@example.com"
      }
    end
    let(:fragment) { "#/requests/posts_create" }

    context "with valid attributes" do
      it { expect { subject }.not_to raise_error }
    end

    [
      [{ data: { attributes: {} } }, "with missing attributes"],
      [{ data: {} }, "missing attributes object"],
      [{}, "missing data object"]
    ].each do |attributes, description|
      context "with #{description}" do
        let(:body) { attributes }

        it { expect { subject }.to raise_error Errors::BadRequest }
      end
    end

    context "with invalid, singular type" do
      let(:type) { "post" }

      it { expect { subject }.to raise_error Errors::BadRequest }
    end
  end
end
