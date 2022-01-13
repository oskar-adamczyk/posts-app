# frozen_string_literal: true

module PostsApp
  extend Dry::Configurable

  setting :database do
    setting :adapter
    setting :host
    setting :name
    setting :password
    setting :pool
    setting :port
    setting :username
  end

  setting :environment

  setting :feedbacks_report_crontab

  setting :good_job do
    setting :max_threads
  end

  setting :health_checks

  setting :json_api do
    setting :pagination_links_enabled
  end

  config.database.adapter = ENV.fetch("DATABASE_ADAPTER", "postgresql")
  config.database.name = ENV.fetch("DATABASE_NAME")
  config.database.host = ENV.fetch("DATABASE_HOST")
  config.database.password = ENV.fetch("DATABASE_PASSWORD")
  config.database.pool = ENV.fetch("DATABASE_POOL", "5").to_i
  config.database.port = ENV.fetch("DATABASE_PORT")
  config.database.username = ENV.fetch("DATABASE_USERNAME")

  config.environment = ENV.fetch("ENVIRONMENT", "development")

  config.feedbacks_report_crontab = ENV.fetch("FEEDBACKS_REPORT_CRONTAB", "0 9 * * * Europe/Berlin")

  config.good_job.max_threads = ENV.fetch("GOOD_JOB_MAX_THREADS", "2").to_i

  config.health_checks ||= []
  config.health_checks << "HealthServices::DatabaseCheck" if ENV.fetch("CHECK_DB_HEALTH", "0") == "1"

  config.json_api.pagination_links_enabled = ENV.fetch("JSON_API_PAGINATION_LINKS_ENABLED", "0") == "1"

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
