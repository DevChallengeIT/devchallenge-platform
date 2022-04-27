# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UI::ChallengeRegistrationInfoComponent, type: :component do
  it 'renders registration closed info' do
    render_inline(described_class.new(challenge: build(:challenge, :registration_closed)))

    expect(rendered_component).to have_text I18n.t('messages.challenge_registration_closed')
  end

  it 'renders registration not opened info' do
    render_inline(described_class.new(challenge: build(:challenge, :registration_not_opened)))

    expect(rendered_component).to have_text I18n.t('messages.challenge_registration_not_opened_yet')
  end

  it 'renders invitation to create account' do
    render_inline(described_class.new(challenge: build(:challenge, status: 'ready')))

    expect(rendered_component).to have_text I18n.t('messages.register_to_join')
  end
end
