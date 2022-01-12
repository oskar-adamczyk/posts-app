# frozen_string_literal: true

class FeedbackSerializer < ActiveModel::Serializer
  type :feedbacks

  attributes :comment

  belongs_to :owner, serializer: UserSerializer
  belongs_to :post, serializer: PostSerializer
  belongs_to :user, serializer: UserSerializer

  def post
    return unless object.commentable.is_a? Post

    object.commentable
  end

  def user
    return unless object.commentable.is_a? User

    object.commentable
  end
end
