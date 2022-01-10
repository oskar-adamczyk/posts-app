# frozen_string_literal: true

require_relative "../../app"

Dir[File.join __dir__, "serialized_model_helpers", "*.rb"].each { |file| require file }

module RequestsSpecHelper
  include Rack::Test::Methods

  def app
    App.init
  end

  def current_time
    @current_time ||= Time.current
  end

  def expect_schema_validation_for(fragment:, namespace:, body: nil)
    expect(JsonSchemaServices::Validate).to receive(:new).with(
      hash_including(
        body: body || anything,
        fragment: fragment,
        schema: JsonSchemaServices::Read.call(namespace: namespace).schema
      )
    ).and_call_original
  end

  def json_api_get(headers: nil)
    get url, nil, headers || json_api_headers
  end

  def json_api_headers
    { "Content-Type" => "application/vnd.api+json", "Accept" => "application/vnd.api+json" }
  end

  def json_api_post(headers: nil)
    post url, params.to_json, headers || json_api_headers
  end

  def json_data_ids
    @json_data_ids ||= json_response["data"].map { |resource| resource["id"] }
  end

  def json_included_ids
    @json_included_ids ||= json_response["included"].map { |include| include["id"] }
  end

  def json_included_attrs(type = nil)
    json_response["included"].select { |include| include["type"] == type || type.nil? }
                             .map { |include| include.fetch("attributes", {}) }
  end

  def json_response
    @json_response ||= JSON.parse last_response.body
  end

  def params
    {}
  end
end
