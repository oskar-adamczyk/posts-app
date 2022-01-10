# frozen_string_literal: true

module ErrorHandlers
  class UnsupportedMediaType < Base
    register_self Errors::UnsupportedMediaType

    private

    def perform
      Result.new content: Hash.new(:nothing), options: { status: :unsupported_media_type }
    end
  end
end
