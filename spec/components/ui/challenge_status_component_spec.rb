# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UI::ChallengeStatusComponent, type: :component do
  it 'renders draft status' do
    render_inline(described_class.new(challenge: build(:challenge, status: 'draft')))

    expect(page).to have_css "span[class='inline-flex items-center gap-1.5 py-1.5 px-3 rounded-md text-xs font-medium bg-gray-100 text-gray-800']",
                             text: 'draft'
  end

  it 'renders moderation status' do
    render_inline(described_class.new(challenge: build(:challenge, status: 'moderation')))

    expect(page).to have_css "span[class='inline-flex items-center gap-1.5 py-1.5 px-3 rounded-md text-xs font-medium bg-orange-100 text-orange-800']",
                             text: 'moderation'
  end

  it 'renders canceled status' do
    render_inline(described_class.new(challenge: build(:challenge, status: 'canceled')))

    expect(page).to have_css "span[class='inline-flex items-center gap-1.5 py-1.5 px-3 rounded-md text-xs font-medium bg-red-100 text-red-800']",
                             text: 'canceled'
  end

  it 'renders pending staus' do
    render_inline(described_class.new(challenge: build(:challenge, status:          'ready',
                                                                   registration_at: Time.zone.now + 1.minute)))

    expect(page).to have_css "span[class='inline-flex items-center gap-1.5 py-1.5 px-3 rounded-md text-xs font-medium bg-gray-100 text-gray-800']",
                             text: 'pending'
  end

  it 'renders registration staus' do
    render_inline(described_class.new(challenge: build(:challenge, status: 'ready',
registration_at: Time.zone.now - 1.minute, start_at: Time.zone.now + 1.minute)))

    expect(page).to have_css "span[class='inline-flex items-center gap-1.5 py-1.5 px-3 rounded-md text-xs font-medium bg-blue-100 text-blue-800']",
                             text: 'registration'
  end

  it 'renders live staus' do
    render_inline(described_class.new(challenge: build(:challenge, status: 'ready', start_at: Time.zone.now - 1.minute,
finish_at: Time.zone.now + 1.minute)))

    expect(page).to have_css "span[class='inline-flex items-center gap-1.5 py-1.5 px-3 rounded-md text-xs font-medium bg-green-100 text-green-800']",
                             text: 'live'
  end

  it 'renders completed staus' do
    render_inline(described_class.new(challenge: build(:challenge, status: 'ready',
registration_at: Time.zone.now - 3.minutes, start_at: Time.zone.now - 2.minutes, finish_at: Time.zone.now - 1.minute)))

    expect(page).to have_css "span[class='inline-flex items-center gap-1.5 py-1.5 px-3 rounded-md text-xs font-medium bg-violet-100 text-violet-800']",
                             text: 'completed'
  end
end
