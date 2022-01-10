# frozen_string_literal: true

class BaseService
  include ActiveSupport::Callbacks

  define_callbacks :perform

  class BaseServiceResult < Dry::Struct
    include Dry.Types default: :nominal
  end

  def initialize(**params)
    @params = params.to_h
  end

  def self.call(**params)
    new(**params).call
  end

  def call
    run_callbacks :perform do
      perform.tap do |result|
        raise TypeError "Invalid result type" unless result.is_a? BaseServiceResult
      end
    end
  end

  private

  attr_reader :params

  # :nocov:
  def perform
    raise NotImplementedError
  end
  # :nocov:
end
