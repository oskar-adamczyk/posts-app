# frozen_string_literal: true

FactoryBot.define do
  factory :rating do
    rate { rand(1..5) }
    post
  end
end
