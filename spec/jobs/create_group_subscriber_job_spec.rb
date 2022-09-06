# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateGroupSubscriberJob do
  let(:challenge) { create(:challenge, remote_email_group_id: '111519893') }
  let(:member) { create(:member, challenge:, user:) }

  context 'when new user' do
    let(:user) { create(:user, email: 'tester@devchallenge.it') }

    it 'executes MailerLite::Client#create_group_subscriber' do
      VCR.use_cassette('mailerlite/create_group_subscriber_success') do
        described_class.perform_now(member:)
      end
    end
  end

  context 'when unsubscibed user' do
    let(:user) { create(:user, email: 'vladyslav.shut@gmail.com') }

    it 'executes MailerLite::Client#create_group_subscriber' do
      VCR.use_cassette('mailerlite/create_group_subscriber_failure') do
        described_class.perform_now(member:)
      end
    end
  end
end
