# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateSendpulseSubscriberJob do
  let(:user) { create(:user, email: 'tester@devchallenge.it', full_name: 'Test User') }

  it 'sends event to SendPulse' do
    VCR.use_cassette('sendpulse/create_subscriber_event') do
      expect { described_class.perform_now(user:) }.not_to raise_error
    end
  end
end
