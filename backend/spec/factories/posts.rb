# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    average_rate { rand(1.0...5.0) }
    content { Faker::Movies::LordOfTheRings.quote }
    origin_ip { Faker::Internet.ip_v4_address }
    sequence(:title) { |i| "#{i}.#{Faker::Movies::LordOfTheRings.character}" }
    user
  end
end
