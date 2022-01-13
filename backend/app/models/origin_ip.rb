# frozen_string_literal: true

require "resolv"

class OriginIp < ApplicationRecord
  validates :address,
            presence: true,
            length: { allow_blank: true, maximum: 15, minimum: 7 },
            format: { with: Resolv::IPv4::Regex },
            uniqueness: { case_sensitive: false }
  validates :authors,
            presence: true,
            length: { allow_blank: true, minimum: 1 }
end
