# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  type :users

  attributes :email
end
