# frozen_string_literal: true

require_relative "app"

Rack::Handler::Puma.run(
  App.init,
  Port: ENV.fetch("PORT", 3000),
  Verbose: true,
  Threads: "0:#{ENV.fetch('MAX_THREADS', 5)}"
)
