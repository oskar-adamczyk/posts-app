# frozen_string_literal: true

module RatingServices
  class RatePost < RetriablePersist
    set_callback :save_resource, :before, :post
    set_callback :save_resource, :after, :patch_post_average_rate!

    class Result < BaseServiceResult
      attribute :rating, Strict::Any.constrained(type: Rating)
    end

    private

    def patch_post_average_rate!
      post.update!(average_rate: average_rate)
    end

    def average_rate
      @average_rate ||= Post.joins(:ratings).reselect("AVG(rate) as avg_rate").find_by(id: post_id).avg_rate.to_f
    end

    def post
      @post ||= Post.find(post_id)
    rescue ActiveRecord::RecordNotFound
      raise Errors::NotFound
    end

    def post_id
      @post_id ||= attributes.fetch(:post_id)
    end

    def resource
      @resource ||= Rating.new
    end

    def result
      Result.new rating: resource
    end
  end
end
