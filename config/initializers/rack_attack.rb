# frozen_string_literal: true

require 'redis'

Rack::Attack.enabled = ENV['ENABLE_RACK_ATTACK']
Rack::Attack.cache.store = Rack::Attack::StoreProxy::RedisStoreProxy.new(Redis.new)

Rack::Attack.throttle('requests by ip', limit: 5, period: 2, &:ip)

ActiveSupport::Notifications.subscribe(/rack_attack/) do |_name, _start, _finish, _request_id, payload|
  req = payload[:request]
  Rails.logger.info "ATTACK throttle remote Ip: #{req.ip}" if %i[throttle].include? req.env['rack.attack.match_type']
end
