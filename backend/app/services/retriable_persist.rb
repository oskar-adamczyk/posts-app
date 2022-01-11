# frozen_string_literal: true

class RetriablePersist < BasePersist
  def initialize(**params)
    super(**params)
    raise ArgumentError "Invalid max retries param" unless max_retries_valid?

    @max_retries = params.fetch :max_retries
  end

  private

  attr_reader :max_retries

  def isolation
    :serializable
  end

  def max_retries_valid?
    params.fetch(:max_retries).is_a? Integer
  end

  def perform
    @retry_attempt ||= 0
    super
  rescue ActiveRecord::SerializationFailure => e
    # TODO: better log and monitor error
    pp "SerializationFailure", e.backtrace
    raise_serialization_failure! e if max_retries_reached?

    @retry_attempt += 1
    sleep(rand / 100)
    retry
  end

  def max_retries_reached?
    @retry_attempt == max_retries
  end

  def raise_serialization_failure!(error)
    @retry_attempt = nil
    raise error
  end
end
