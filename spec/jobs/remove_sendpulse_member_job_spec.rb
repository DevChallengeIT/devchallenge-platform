# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RemoveSendpulseMemberJob do
  it 'sends event to SendPulse' do
    VCR.use_cassette('sendpulse/remove_member_event') do
      expect do
        described_class.perform_now(
          email:     'tester@devchallenge.it',
          phone:     '',
          challenge: 'Test Challenge',
          fullname:  'Test User'
        )
      end.not_to raise_error
    end
  end
end
