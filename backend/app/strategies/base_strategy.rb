# frozen_string_literal: true

class BaseStrategy
  class BaseStrategyResult < Dry::Struct
    include Dry.Types default: :nominal
  end

  def self.register_self(key)
    strategies.register self, key
  end

  # :nocov:
  def self.strategies
    raise NotImplementedError
  end
  # :nocov:

  def call
    perform.tap do |result|
      raise TypeError "Invalid result type" unless result.is_a? BaseStrategyResult
    end
  end

  private

  # :nocov:
  def perform
    raise NotImplementedError
  end
  # :nocov:
end
