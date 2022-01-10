# frozen_string_literal: true

module JsonSchemaServices
  class Read < BaseService
    DEFINITIONS = %i[definitions responses requests subdefinitions].freeze

    class Result < BaseServiceResult
      attribute :schema, Strict::Hash
    end

    private

    def perform
      Result.new schema: definitions
    end

    def common_definitions
      Dir[
        File.join "app/json_schemas/api/commons/*.json"
      ].inject({ commons: {} }) do |defs, file|
        defs.tap do |obj|
          obj[:commons][File.basename(file, ".json").to_sym] = JSON.parse File.read(file)
        end
      end
    end

    def definitions
      DEFINITIONS.inject({}) do |definitions, definition|
        Dir[
          File.join "app", "json_schemas", namespace, definition.to_s, "*.json"
        ].inject(definitions.tap { |obj| obj[definition] = {} }) do |defs, file|
          enrich_definition(defs, definition, file)
        end
      end.merge(common_definitions)
    end

    def enrich_definition(definitions, definition_name, file)
      definitions.tap do |obj|
        obj[definition_name][File.basename(file, ".json").to_sym] = JSON.parse File.read(file)
      end
    end

    def namespace
      @namespace ||= params.fetch(:namespace).join("/")
    end
  end
end
