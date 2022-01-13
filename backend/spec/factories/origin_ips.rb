# frozen_string_literal: true

FactoryBot.define do
  factory :origin_ip do
    address { Faker::Internet.ip_v4_address }
    authors { [Faker::Internet.email] }
  end
end
