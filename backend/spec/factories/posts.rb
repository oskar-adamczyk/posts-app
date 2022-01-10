# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    content { Faker::Movies::LordOfTheRings.quote }
    origin_ip { Faker::Internet.ip_v4_address }
    sequence(:title) { |i| "#{i}.#{Faker::Movies::LordOfTheRings.character}" }
    user
  end
end
