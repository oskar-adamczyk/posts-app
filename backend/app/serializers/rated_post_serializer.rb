# frozen_string_literal: true

class RatedPostSerializer < ActiveModel::Serializer
  type :posts

  attributes :average_rate
end
