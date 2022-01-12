# frozen_string_literal: true

FactoryBot.define do
  factory :feedback do
    comment { Faker::Movies::LordOfTheRings.quote }

    trait :post do
      commentable { build(:post) }
    end

    trait :user do
      commentable { build(:user) }
    end
  end
end
