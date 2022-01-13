# frozen_string_literal: true

class Database
  def self.config
    {
      adapter: PostsApp.config.database.adapter,
      host: PostsApp.config.database.host,
      password: PostsApp.config.database.password,
      port: PostsApp.config.database.port,
      username: PostsApp.config.database.username
    }.merge(additional_database_config)
  end

  private

  def self.additional_database_config
    database = PostsApp.config.database.name
    database += "_test" if PostsApp.test?
    {
      database: database,
      pool: PostsApp.config.database.pool + PostsApp.config.good_job.max_threads
    }
  end

  private_class_method :additional_database_config
end
