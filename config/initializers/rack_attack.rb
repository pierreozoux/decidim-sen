# frozen_string_literal: true

require "rack/attack"

if ENV["POD_IP"].present?
  Rack::Attack.safelist("mark any authenticated access safe") do |request|
    Rails.logger.info("SAFELISTED REQUEST: #{request.ip}")
    request.env["X-HTTP_SAFELIST"] == "true" && req.ip == ENV["POD_IP"]
  end
end

Rack::Attack.enabled = ActiveRecord::Type::Boolean.new.cast(ENV.fetch("RACK_ATTACK_DISABLED", "true"))

if Rails.env.production?
  class Rack::Attack
    throttle("req/ip", limit: Decidim.throttling_max_requests, period: Decidim.throttling_max_requests) do |req|
      Rails.logger.warn("[Rack::Attack] [THROTTLE - req / ip] :: #{req.ip} :: #{req.path} :: #{req.GET}")
      req.ip unless req.path.start_with?("/assets")
    end
  end
end
