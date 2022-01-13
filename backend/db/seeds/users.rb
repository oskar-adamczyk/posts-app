# frozen_string_literal: true

def seed_users
  users_count = ENV.fetch("USERS_COUNT", "50").to_i

  return puts "Skipping seeding users" unless users_count.positive?

  progress_bar = ProgressBar.new users_count

  User.insert_all(
    users_count.times.map do
      progress_bar.increment!
      FactoryBot.build(:user).attributes.merge(
        created_at: Time.current,
        id: SecureRandom.uuid,
        updated_at: Time.current
      )
    end,
    unique_by: :index_users_on_lower_email
  )

  puts "Seeded #{users_count} users"
end
