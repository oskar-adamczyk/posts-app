# frozen_string_literal: true

class RatingSerializer < ActiveModel::Serializer
  type :ratings

  attributes :rate

  belongs_to :post, serializer: RatedPostSerializer
end
