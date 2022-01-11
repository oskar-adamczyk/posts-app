# frozen_string_literal: true

module PostServices
  class Fetch < BaseFetch
    class Result < BaseServiceResult
      attribute :posts, Strict::Any.constrained(type: ActiveRecord::Relation)
    end

    private

    def scope
      @scope ||= Post.order(average_rate: :desc)
    end

    def result
      Result.new posts: resources
    end
  end
end
