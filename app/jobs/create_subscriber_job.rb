# frozen_string_literal: true

class CreateSubscriberJob < ApplicationJob
  def perform(user:)
    return unless Rails.application.credentials.mailerlite.api_key

    client = MailerLite::Client.new(api_key: Rails.application.credentials.mailerlite.api_key)
    client.create_subscriber(email: user.email, name: user.full_name)
    client.create_group_subscriber(
      Rails.application.credentials.mailerlite.general_group_id,
      { email: user.email }
    )
  end
end
