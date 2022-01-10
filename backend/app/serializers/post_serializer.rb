# frozen_string_literal: true

class PostSerializer < ActiveModel::Serializer
  type :posts

  attributes :content, :origin_ip, :title
end
