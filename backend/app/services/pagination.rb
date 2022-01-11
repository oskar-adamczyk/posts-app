# frozen_string_literal: true

class Pagination < Dry::Struct
  include Dry.Types(default: :nominal)

  attribute :page, Coercible::Integer.optional
  attribute :per_page, Coercible::Integer.optional.constrained(gteq: 1, lteq: 200)
end
