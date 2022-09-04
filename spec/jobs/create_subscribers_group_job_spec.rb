# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateSubscribersGroupJob do
  let(:challenge) { create(:challenge, slug: 'test-challenge') }

  it 'executes MailerLite::Client#create_group' do
    VCR.use_cassette('mailerlite/create_group_success') do
      described_class.perform_now(challenge:)
    end
  end
end
