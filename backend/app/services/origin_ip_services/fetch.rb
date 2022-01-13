# frozen_string_literal: true

module OriginIpServices
  class Fetch < BaseFetch
    class Result < BaseServiceResult
      attribute :origin_ips, Strict::Any.constrained(type: ActiveRecord::Relation)
    end

    private

    def scope
      @scope ||= OriginIp
    end

    def result
      Result.new origin_ips: resources
    end
  end
end
