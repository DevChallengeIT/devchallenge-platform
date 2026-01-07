# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateSubscriberJob do
  context 'when new user' do
    let(:user) { create(:user) }

    it 'executes MailerLite::Client#create_subscriber' do
      VCR.use_cassette('mailerlite/create_subscriber_success') do
        expect { described_class.perform_now(user:) }.not_to raise_error
      end
    end
  end

  context 'when unsubscibed user' do
    let(:user) { create(:user, email: 'vladyslav.shut@gmail.com') }

    it 'executes MailerLite::Client#create_group_subscriber' do
      VCR.use_cassette('mailerlite/create_subscriber_failure') do
        expect { described_class.perform_now(user:) }.not_to raise_error
      end
    end
  end
end
