# frozen_string_literal: true

class RemoveSendpulseMemberJob < ApplicationJob
  SENDPULSE_EVENT_URL = 'https://events.sendpulse.com/events/id/d42eed421367484bb4967b13caeb1aad/8623852'

  def perform(email:, phone:, challenge:, fullname:)
    HTTP.post(
      SENDPULSE_EVENT_URL,
      json: {
        email:,
        phone:,
        challenge:,
        fullname:
      }
    )
  end
end
