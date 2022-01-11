# frozen_string_literal: true

module OriginIpServices
  class Fetch < BaseFetch
    class Result < BaseServiceResult
      attribute :origin_ips, Strict::Any
    end

    class OriginIps < Dry::Struct
      include Dry.Types default: :nominal

      attribute :current_page, Strict::Integer
      attribute :next_page, Strict::Integer.optional
      attribute :origin_ips, Strict::Array.of(Virtual::OriginIp)
      attribute :size, Strict::Integer
      attribute :total_pages, Strict::Integer

      delegate :map, to: :origin_ips
    end

    private

    def scope
      @scope ||= User.joins(:posts)
                     .group(:origin_ip)
                     .reselect("posts.origin_ip as ip, ARRAY_AGG(users.email) AS authors")
    end

    def result
      Result.new origin_ips: origin_ips
    end

    def origin_ips
      @origin_ips ||= OriginIps.new(
        current_page: resources.current_page,
        next_page: resources.next_page,
        origin_ips: resources.map { |resource| Virtual::OriginIp.new(id: resource.ip, authors: resource.authors) },
        size: resources.size,
        total_pages: resources.total_pages
      )
    end
  end
end
