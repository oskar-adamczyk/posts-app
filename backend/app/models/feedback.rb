# frozen_string_literal: true

class Feedback < ApplicationRecord
  belongs_to :commentable, polymorphic: true

  validates :comment,
            presence: true,
            length: { allow_blank: true, maximum: 256, minimum: 2 }
end
