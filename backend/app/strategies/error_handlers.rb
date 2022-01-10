# frozen_string_literal: true

module ErrorHandlers
  extend BaseStrategies
end

(
  Dir[File.join __dir__, "error_handlers", "*.rb"] -
    Dir[File.join __dir__, "error_handlers/base.rb"]
).each { |file| require file }
