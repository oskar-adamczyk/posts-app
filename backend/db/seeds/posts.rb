# frozen_string_literal: true

def seed_posts
  posts_count = ENV.fetch("POSTS_COUNT", "200000").to_i

  return puts "Skipping seeding posts" unless posts_count.positive?

  progress_bar = ProgressBar.new posts_count

  Post.insert_all(
    posts_count.times.map do
      progress_bar.increment!
      build_post_attrs
    end,
    unique_by: :index_posts_on_lower_title
  )

  puts "Seeded #{posts_count} posts"
end

def build_post_attrs
  user = User.order("RANDOM()").first || FactoryBot.create(:user)
  origin_ip = @origin_ips.sample
  @authors[origin_ip] ||= []
  @authors[origin_ip] << user.email unless @authors.values.any? { |authors| authors.include? user.email }

  FactoryBot.build(:post, user: user, origin_ip: origin_ip).attributes.merge(
    created_at: Time.current,
    id: SecureRandom.uuid,
    updated_at: Time.current
  )
end
