# frozen_string_literal: true

class CreateSubscribersGroupJob < ApplicationJob
  def perform(challenge:)
    return unless Rails.application.credentials.mailerlite.api_key

    client = MailerLite::Client.new(api_key: Rails.application.credentials.mailerlite.api_key)
    group = client.create_group("platform-#{challenge.slug}")
    challenge.update!(remote_email_group_id: group['id'])
  end
end
