# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateSubscriberJob do
  let(:user) { create(:user) }

  it 'executes MailerLite::Client#create_subscriber' do
    VCR.use_cassette('mailerlite/create_subscriber_success') do
      described_class.perform_now(user:)
    end
  end
end
