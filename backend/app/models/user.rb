# frozen_string_literal: true

class User < ApplicationRecord
  has_many :posts

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { allow_blank: true, maximum: 254, minimum: 6 },
            format: { allow_blank: true, with: /\A[^@\s]+@[^@\s]+\z/ }
end
