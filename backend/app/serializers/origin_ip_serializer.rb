# frozen_string_literal: true

class OriginIpSerializer < ActiveModel::Serializer
  type :origin_ips

  attributes :authors
end
