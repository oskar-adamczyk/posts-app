# frozen_string_literal: true

module ErrorHandlers
  class Base < BaseStrategy
    class Result < BaseStrategyResult
      STATUSES = Rack::Utils::HTTP_STATUS_CODES
                 .values
                 .map { |status| status.gsub(" ", "_").underscore.to_sym }
                 .freeze

      attribute :content, Strict::Hash
      attribute :options do
        attribute :serializer,
                  Strict::Class
                    .enum(ActiveModel::Serializer::ErrorSerializer)
                    .meta(omittable: true)
        attribute :status, Strict::Symbol.enum(*STATUSES)
      end
    end

    def initialize(error:)
      super()
      @error = error
    end

    def self.call(error:)
      new(error: error).call
    end

    def self.strategies
      ErrorHandlers
    end

    private

    attr_reader :error
  end
end
