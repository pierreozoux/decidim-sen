# frozen_string_literal: true

Rack::Attack.safelist_ip(ENV["POD_IP"]) if ENV["POD_IP"].present?
Rack::Attack.enabled = false if ENV.fetch("RACK_ATTACK_DISABLED", true)

if Rails.env.production?
  class Rack::Attack
    throttle("req/ip", limit: Decidim.throttling_max_requests, period: Decidim.throttling_max_requests) do |req|
      Rails.logger.warn("[Rack::Attack] [THROTTLE - req / ip] :: #{req.ip} :: #{req.path} :: #{req.GET}")
      req.ip unless req.path.start_with?("/assets")
    end
  end
end
