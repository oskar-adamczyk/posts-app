# frozen_string_literal: true

module Virtual
  class Health < Dry::Struct
    include Dry.Types(default: :nominal)

    attribute :id, Strict::Any.constrained(type: ActiveSupport::TimeWithZone)
    attribute :status, Strict::Symbol.enum(*%i[healthy failing])

    def healthy?
      status == :healthy
    end

    def read_attribute_for_serialization(name)
      attributes.fetch(name)
    end
  end
end
