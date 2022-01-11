# frozen_string_literal: true

class Rating < ApplicationRecord
  belongs_to :post

  validates :rate,
            presence: true,
            numericality: {
              allow_blank: true, only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5
            }
end
