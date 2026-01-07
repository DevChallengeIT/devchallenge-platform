# frozen_string_literal: true

class CreateSendpulseSubscriberJob < ApplicationJob
  SENDPULSE_EVENT_URL = 'https://events.sendpulse.com/events/id/3b45007263354ccf96677a37f3d05b29/8623852'

  def perform(user:)
    HTTP.post(
      SENDPULSE_EVENT_URL,
      json: {
        email: user.email,
        phone: user.phone_number.presence || '',
        name:  user.full_name
      }
    )
  end
end
