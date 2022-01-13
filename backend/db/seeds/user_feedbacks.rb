# frozen_string_literal: true

def seed_user_feedbacks
  user_feedbacks_count = ENV.fetch("USER_FEEDBACKS_COUNT", "200000").to_i

  return puts "Skipping seeding user feedbacks" unless user_feedbacks_count.positive?

  progress_bar = ProgressBar.new user_feedbacks_count

  Feedback.insert_all(
    user_feedbacks_count.times.map do
      progress_bar.increment!
      build_feedback_attrs
    end,
    unique_by: :index_feedbacks_commentable_user
  )

  puts "Seeded #{user_feedbacks_count} user feedbacks"
end

def build_feedback_attrs
  user = User.order("RANDOM()").first || FactoryBot.create(:user)
  owner = User.order("RANDOM()").first || FactoryBot.create(:user)
  FactoryBot.build(:feedback, commentable: user).attributes.merge(
    created_at: Time.current,
    id: SecureRandom.uuid,
    updated_at: Time.current,
    user_id: owner.id
  )
end
