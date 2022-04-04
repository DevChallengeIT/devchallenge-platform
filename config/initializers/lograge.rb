# frozen_string_literal: true

Rails.application.configure do
  config.lograge.enabled = true
  config.lograge.base_controller_class = ['UI::BaseController']

  config.lograge.custom_options = lambda do |event|
    { time: Time.current, user: event.payload[:user_id] }
  end
end
