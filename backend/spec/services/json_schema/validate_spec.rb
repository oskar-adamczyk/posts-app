# frozen_string_literal: true

require "spec_helper"

Dir[File.join __dir__, "validator_requests_contexts", "*.rb"].each { |file| require file }

describe JsonSchemaServices::Validate do
  subject { described_class.call(body: body.to_json, fragment: fragment, schema: schema) }

  let(:body) do
    data = {
      attributes: attributes,
      type: type
    }
    data.merge!(id: SecureRandom.uuid) if fragment.include? "response"
    {
      data: data
    }
  end
  let(:schema) { JsonSchemaServices::Read.call(namespace: namespace).schema }

  include_context "validating feedbacks create"
  include_context "validating posts create"
  include_context "validating posts ratings create"
end
