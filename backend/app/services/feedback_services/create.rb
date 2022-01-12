# frozen_string_literal: true

module FeedbackServices
  class Create < BasePersist
    set_callback :assign_attributes, :before, :assign_relations!

    class Result < BaseServiceResult
      attribute :owner_feedbacks, Strict::Any.constrained(type: ActiveRecord::Relation)
    end

    private

    def assign_relations!
      @attributes = @attributes.merge(
        commentable: commentable,
        owner: owner
      ).except :owner_id, :post_id, :user_id
    end

    def commentable
      return @commentable if @commentable.present?

      validate_commentable!

      return @commentable ||= post if @attributes[:post_id].present?

      @commentable ||= user
    end

    def owner
      @owner ||= User.find attributes.fetch(:owner_id)
    rescue ActiveRecord::RecordNotFound
      raise Errors::NotFound
    end

    def post
      @post ||= Post.find attributes.fetch(:post_id)
    rescue ActiveRecord::RecordNotFound
      raise Errors::NotFound
    end

    def user
      @user ||= User.find attributes.fetch(:user_id)
    rescue ActiveRecord::RecordNotFound
      raise Errors::NotFound
    end

    def validate_commentable!
      return unless @attributes[:post_id] && @attributes[:user_id]

      resource.errors.add(:commentable, :invalid)
      raise Errors::UnprocessableEntity.new(entity: resource)
    end

    def resource
      @resource ||= Feedback.new
    end

    def result
      Result.new owner_feedbacks: owner.reload.feedbacks
    end
  end
end
