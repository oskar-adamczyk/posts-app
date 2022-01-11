# frozen_string_literal: true

class ListedPostSerializer < ActiveModel::Serializer
  type :posts

  attributes :content, :title
end
