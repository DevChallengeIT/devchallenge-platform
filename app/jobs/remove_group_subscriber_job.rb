# frozen_string_literal: true

class RemoveGroupSubscriberJob < ApplicationJob
  def perform(email:, group_id:)
    return unless Rails.application.credentials.mailerlite.api_key

    sleep 2 if Rails.env.production?

    client = MailerLite::Client.new(api_key: Rails.application.credentials.mailerlite.api_key)
    client.delete_group_subscriber(group_id, email)
  end
end
