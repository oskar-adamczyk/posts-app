# frozen_string_literal: true

class ApplicationJob < ActiveJob::Base
  discard_on ActiveJob::DeserializationError

  retry_on ActiveRecord::Deadlocked
end
