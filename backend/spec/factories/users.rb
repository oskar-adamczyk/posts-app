# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |i| "#{i}-#{Faker::Internet.email}" }
  end
end
