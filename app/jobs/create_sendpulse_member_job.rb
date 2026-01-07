# frozen_string_literal: true

class CreateSendpulseMemberJob < ApplicationJob
  SENDPULSE_EVENT_URL = 'https://events.sendpulse.com/events/id/c01e7fbb28704dbc93e3491d06534d71/8623852'

  def perform(member:)
    HTTP.post(
      SENDPULSE_EVENT_URL,
      json: {
        email:     member.user.email,
        phone:     member.user.phone_number.presence || '',
        name:      member.user.full_name,
        challenge: member.challenge.title
      }
    )
  end
end
