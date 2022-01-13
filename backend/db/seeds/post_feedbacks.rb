# frozen_string_literal: true

def seed_post_feedbacks
  post_feedbacks_count = ENV.fetch("POST_FEEDBACKS_COUNT", "200000").to_i

  return puts "Skipping seeding post feedbacks" unless post_feedbacks_count.positive?

  progress_bar = ProgressBar.new post_feedbacks_count

  Feedback.insert_all(
    post_feedbacks_count.times.map do
      progress_bar.increment!
      build_feedback_attrs
    end,
    unique_by: :index_feedbacks_commentable_user
  )

  puts "Seeded #{post_feedbacks_count} post feedbacks"
end

def build_feedback_attrs
  post = Post.order("RANDOM()").first || FactoryBot.create(:post)
  owner = User.order("RANDOM()").first || FactoryBot.create(:user)
  FactoryBot.build(:feedback, commentable: post).attributes.merge(
    created_at: Time.current,
    id: SecureRandom.uuid,
    updated_at: Time.current,
    user_id: owner.id
  )
end
