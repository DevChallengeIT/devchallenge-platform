# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RemoveGroupSubscriberJob do
  it 'executes MailerLite::Client#delete_group_subscriber' do
    VCR.use_cassette('mailerlite/delete_group_subscriber_success') do
      described_class.perform_now(email: 'test-user-1@devchallenge.it', group_id: '111519893')
    end
  end
end
