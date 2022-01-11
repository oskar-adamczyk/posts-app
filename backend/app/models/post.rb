# frozen_string_literal: true

require "resolv"

class Post < ApplicationRecord
  belongs_to :user
  has_many :ratings

  validates :content,
            presence: true,
            length: { allow_blank: true, maximum: 256, minimum: 2 }
  validates :origin_ip,
            presence: true,
            length: { allow_blank: true, maximum: 15, minimum: 7 },
            format: { with: Resolv::IPv4::Regex }
  validates :title,
            presence: true,
            length: { allow_blank: true, maximum: 256, minimum: 2 },
            uniqueness: { case_sensitive: false }
end
