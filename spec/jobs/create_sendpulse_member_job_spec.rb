# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateSendpulseMemberJob do
  let(:challenge) { create(:challenge) }
  let(:user) { create(:user, email: 'tester@devchallenge.it', full_name: 'Test User') }
  let(:member) { create(:member, challenge:, user:) }

  it 'sends event to SendPulse' do
    VCR.use_cassette('sendpulse/create_member_event') do
      expect { described_class.perform_now(member:) }.not_to raise_error
    end
  end
end
