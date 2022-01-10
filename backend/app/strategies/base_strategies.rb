# frozen_string_literal: true

module BaseStrategies
  def register(strategy, key)
    @registry ||= {}
    @registry[key] = strategy
  end

  def strategy(key)
    @registry.fetch key
  end

  attr_reader :registry
end
