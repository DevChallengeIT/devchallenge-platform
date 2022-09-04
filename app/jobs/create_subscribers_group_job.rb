# frozen_string_literal: true

class CreateSubscribersGroupJob < ApplicationJob
  def perform(challenge:)
    return unless Rails.application.credentials.mailerlite_api_key

    client = MailerLite::Client.new(api_key: Rails.application.credentials.mailerlite_api_key)
    client.create_group("platform-#{challenge.slug}")
  end
end
