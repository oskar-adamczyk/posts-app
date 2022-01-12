# frozen_string_literal: true

require_relative "./shared_json_api_context"

RSpec.shared_context "validating posts create", shared_context: :metadata do
  context "validating posts create" do
    let(:attributes) { valid_attrs }
    let(:attributes) { valid_attrs }
    let(:type) { "posts" }
    let(:namespace) { %w[api v1] }

    let(:valid_attrs) do
      {
        content: content,
        origin_ip: "127.0.0.1",
        title: title,
        user_email: "test@example.com"
      }
    end
    let(:content) { "test content" }
    let(:title) { "test title" }
    let(:fragment) { "#/requests/posts_create" }

    [
      ["a", "too short content"],
      [257.times.map { "a" }.join, "too long content"]
    ].each do |content, description|
      context "with #{description}" do
        let(:content) { content }

        it { expect { subject }.to raise_error Errors::BadRequest }
      end
    end

    [
      ["a", "too short title"],
      [257.times.map { "a" }.join, "too long title"]
    ].each do |title, description|
      context "with #{description}" do
        let(:title) { title }

        it { expect { subject }.to raise_error Errors::BadRequest }
      end
    end

    context "with invalid, singular type" do
      let(:type) { "post" }

      it { expect { subject }.to raise_error Errors::BadRequest }
    end

    include_context "validating base json api body context"
  end
end
