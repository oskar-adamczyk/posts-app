# frozen_string_literal: true

def seed_origin_ips
  origin_ips_count = @origin_ips.count

  return puts "Skipping seeding origin ips" unless origin_ips_count.positive?

  progress_bar = ProgressBar.new origin_ips_count

  OriginIp.insert_all(
    @origin_ips.map do |address|
      progress_bar.increment!
      {
        address: address,
        authors: @authors[address],
        created_at: Time.current,
        id: SecureRandom.uuid,
        updated_at: Time.current
      }
    end,
    unique_by: :address
  )

  puts "Seeded #{origin_ips_count} origin ips"
end
