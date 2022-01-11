# frozen_string_literal: true

class HealthSerializer < ActiveModel::Serializer
  type :healths

  attributes :status

  def id
    object.id.iso8601
  end
end
