# frozen_string_literal: true

FactoryBot.define do
  factory :feedback do
    comment { Faker::Movies::LordOfTheRings.quote }
    owner { build :user }

    trait :for_post do
      commentable { build(:post) }
    end

    trait :for_user do
      commentable { build(:user) }
    end
  end
end
