# frozen_string_literal: true

class Database
  def self.config
    database = ENV.fetch("DATABASE_NAME")
    database += "_test" if ENV.fetch("ENVIRONMENT") == "test"
    {
      adapter: ENV.fetch("DATABASE_ADAPTER"),
      database: database,
      host: ENV.fetch("DATABASE_HOST"),
      password: ENV.fetch("DATABASE_PASSWORD"),
      port: ENV.fetch("DATABASE_PORT"),
      username: ENV.fetch("DATABASE_USERNAME")
    }
  end
end
