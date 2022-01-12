# frozen_string_literal: true

class Feedback < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :owner, class_name: User.name, foreign_key: :user_id
  belongs_to :post, foreign_key: "commentable_id"

  def post
    return unless commentable_type == Post.name

    super
  end

  validates :comment,
            presence: true,
            length: { allow_blank: true, maximum: 256, minimum: 2 }
  validates :owner,
            uniqueness: { scope: :commentable }
end
