# frozen_string_literal: true

require_relative "app"

Rack::Handler::Puma.run(App.init, Port: 3000, Verbose: true)
