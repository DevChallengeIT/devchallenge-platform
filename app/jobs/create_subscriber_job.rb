# frozen_string_literal: true

class CreateSubscriberJob < ApplicationJob
  def perform(user:)
    return unless Rails.application.credentials.mailerlite_api_key

    client = MailerLite::Client.new(api_key: Rails.application.credentials.mailerlite_api_key)
    client.create_subscriber(email: user.email, name: user.full_name)
  end
end
