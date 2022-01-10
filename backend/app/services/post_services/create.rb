# frozen_string_literal: true

module PostServices
  class Create < BasePersist
    set_callback :assign_attributes, :before, :assign_author!

    class Result < BaseServiceResult
      attribute :post, Strict::Any.constrained(type: Post)
    end

    private

    def assign_author!
      @attributes = @attributes.merge(user: author).except :user_email
    end

    def author
      @author ||= User.find_or_create_by! email: attributes.fetch(:user_email)
    end

    def resource
      @resource ||= Post.new
    end

    def result
      Result.new post: resource
    end
  end
end
