# frozen_string_literal: true

require "bundler/setup"
require "factory_bot"
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

require_relative "./support/requests_spec_helper"
require_relative "../config/database"
require_relative "../config/config"

SimpleCov.start
SimpleCov.minimum_coverage 95

Dir[File.join __dir__, "./factories/", "*.rb"].each { |file| require_relative file }

ActiveSupport::Dependencies.autoload_paths +=
  %w[
    app/controllers
    app/errors
    app/models
    app/serializers
    app/services
    app/strategies
  ]

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

Time.zone = "Europe/Berlin"
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :active_record
    with.library :active_model
  end
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true

    expectations.syntax = %i[should expect]
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.include FactoryBot::Syntax::Methods

  FactoryBot.define do
    trait :soft_deleted do
      deleted_at { Time.zone.now }
    end
  end

  config.define_derived_metadata { |meta| meta[:aggregate_failures] = true }
  config.before :all do
    ActiveRecord::Base.establish_connection Database.config
    DatabaseCleaner.clean
    DatabaseCleaner.strategy = :truncation
  end
  config.after :all do
    ActiveRecord::Base.remove_connection
  end
  config.after :each do
    DatabaseCleaner.clean
    DatabaseCleaner.strategy = :transaction
  end

  config.include RequestsSpecHelper, type: :request
end
