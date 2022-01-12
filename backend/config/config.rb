# frozen_string_literal: true

module PostsApp
  extend Dry::Configurable

  setting :environment

  setting :feedbacks_report_crontab

  setting :health_checks

  config.environment = ENV.fetch("ENVIRONMENT", "development")

  config.feedbacks_report_crontab = ENV.fetch("FEEDBACKS_REPORT_CRONTAB", "0 9 * * * Europe/Berlin")

  config.health_checks ||= []
  config.health_checks << "HealthServices::DatabaseCheck" if ENV.fetch("CHECK_DB_HEALTH", "0") == "1"

  def self.development?
    config.environment == "development"
  end

  def self.test?
    config.environment == "test"
  end

  def self.production?
    config.environment == "production"
  end
end
