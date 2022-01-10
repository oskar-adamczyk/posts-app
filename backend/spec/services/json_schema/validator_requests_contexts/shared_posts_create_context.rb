# frozen_string_literal: true

Dir[File.join __dir__, "posts_create_subcontexts", "*.rb"].each { |file| require file }

RSpec.shared_context "validating posts create", shared_context: :metadata do
  context "validating posts create" do
    let(:attributes) { valid_attrs }
    let(:attributes) { valid_attrs }
    let(:type) { "posts" }
    let(:namespace) { %w[api v1] }

    context "when validating request" do
      let(:valid_attrs) do
        {
          content: "test content",
          origin_ip: "127.0.0.1",
          title: "test title",
          user_email: "test@example.com"
        }
      end
      let(:fragment) { "#/requests/posts_create" }

      include_context "validating base posts create"
    end

    context "when validating response" do
      let(:valid_attrs) do
        {
          content: "test content",
          origin_ip: "127.0.0.1",
          title: "test title"
        }
      end
      let(:fragment) { "#/responses/posts_create" }

      include_context "validating base posts create"
    end
  end
end
