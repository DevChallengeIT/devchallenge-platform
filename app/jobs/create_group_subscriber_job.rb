# frozen_string_literal: true

class CreateGroupSubscriberJob < ApplicationJob
  def perform(member:)
    return unless Rails.application.credentials.mailerlite.api_key

    client = MailerLite::Client.new(api_key: Rails.application.credentials.mailerlite.api_key)
    client.create_group_subscriber(
      member.challenge.remote_email_group_id,
      { email: member.user.email }
    )
  rescue MailerLite::BadRequest => e
    raise e unless e.message == 'Subscriber type is unsubscribed'

    Rails.logger.info(e.message)
  end
end
