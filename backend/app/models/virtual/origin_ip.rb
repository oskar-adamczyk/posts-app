# frozen_string_literal: true

module Virtual
  class OriginIp < Dry::Struct
    include Dry.Types(default: :nominal)

    attribute :id, Strict::String
    attribute :authors, Strict::Array.of(String)

    def read_attribute_for_serialization(name)
      attributes.fetch(name)
    end
  end
end
