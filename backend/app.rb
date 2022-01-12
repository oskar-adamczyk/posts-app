# frozen_string_literal: true

require "active_support/all"
require "action_controller/metal/strong_parameters"
require "bundler/setup"
require "rack/handler/puma"
require "rubygems"

ENV["ENVIRONMENT"] ||= "development"

Bundler.require :default, ENV.fetch("ENVIRONMENT").to_sym
Dotenv.load if ENV.fetch("ENVIRONMENT", "development") == "development"

require_relative "config/database"
require_relative "config/config"
require_relative "config/router"

class String
  def plural?
    self == pluralize
  end

  def singular?
    !plural?
  end
end

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

class App
  def self.init
    setup
    schedule_jobs

    lambda { |environment|
      Time.zone = "Europe/Berlin"
      request = Rack::Request.new environment
      response = Rack::Response.new

      begin
        action, controller, params = Router.route method: request.request_method, path: request.path
        params.merge!(request.params.deep_symbolize_keys!)
        controller.call(
          action: action, params: params, request: request, response: response
        )
      rescue Router::Error
        response.status = Rack::Utils.status_code :not_found
        response.body = {}
      end
      response.finish
    }
  end

  private

  def self.schedule_jobs
    return if PostsApp.test?

    Rufus::Scheduler.new.tap do |scheduler|
      scheduler.cron PostsApp.config.feedbacks_report_crontab do
        Time.zone = "Europe/Berlin"

        FeedbacksReportJob.perform_now
      end
    end
  end

  def self.setup
    ActiveJob::Base.queue_adapter = ActiveJob::QueueAdapters::GoodJobAdapter.new(
      execution_mode: :async,
      max_threads: 2,
      start_async_on_initialize: true
    )
    ActiveRecord::Base.establish_connection Database.config
    ActiveModelSerializers.config.adapter = :json_api
    ActiveModelSerializers.config.jsonapi_pagination_links_enabled
    ActiveModelSerializers.config.key_transform = :unaltered
    GoodJob.retry_on_unhandled_error = false
  end

  private_class_method :schedule_jobs, :setup
end
