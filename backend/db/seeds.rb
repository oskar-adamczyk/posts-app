# frozen_string_literal: true

require "database_cleaner"
require "factory_bot"
require "bundler/setup"
require "simplecov"

class String
  def plural?
    self == pluralize
  end

  def singular?
    !plural?
  end
end

ENV["ENVIRONMENT"] ||= "test"
Bundler.require :default, :test
Dotenv.load

ActiveSupport::Dependencies.autoload_paths +=
  %w[
    app/controllers
    app/errors
    app/jobs
    app/models
    app/serializers
    app/services
    app/strategies
  ]

require_relative "../config/database"
require_relative "../config/config"
require_relative "../spec/factories/feedbacks"
require_relative "../spec/factories/origin_ips"
require_relative "../spec/factories/posts"
require_relative "../spec/factories/ratings"
require_relative "../spec/factories/users"

ActiveRecord::Base.establish_connection Database.config

if ENV["CLEAR_DB"]
  raise "Do not clear DB on production environment" if ENV["ENVIRONMENT"] == "production"

  DatabaseCleaner.strategy = :truncation
  DatabaseCleaner.clean
end

%w[
  ./seeds/origin_ips
  ./seeds/post_feedbacks
  ./seeds/posts
  ./seeds/user_feedbacks
  ./seeds/users
].each { |file| require_relative file }

@origin_ips = ENV.fetch("ORIGIN_IPS_COUNT", "50").to_i.times.map { Faker::Internet.ip_v4_address }
@authors = {}

seed_users
seed_posts
seed_origin_ips
seed_post_feedbacks
seed_user_feedbacks
