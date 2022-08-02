# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UI::ChallengeStatusComponent, type: :component do
  it 'renders draft status' do
    render_inline(described_class.new(challenge: build(:challenge, status: 'draft')))

    expect(page).to have_css "span[class='rounded font-semibold px-3 py-2 text-white bg-gray-500']",
                             text: 'draft'
  end

  it 'renders moderation staus' do
    render_inline(described_class.new(challenge: build(:challenge, status: 'moderation')))

    expect(page).to have_css "span[class='rounded font-semibold px-3 py-2 text-white bg-orange-500']",
                             text: 'moderation'
  end

  it 'renders ready staus' do
    render_inline(described_class.new(challenge: build(:challenge, status: 'ready')))

    expect(page).to have_css "span[class='rounded font-semibold px-3 py-2 text-white bg-green-500']",
                             text: 'ready'
  end

  it 'renders canceled staus' do
    render_inline(described_class.new(challenge: build(:challenge, status: 'canceled')))

    expect(page).to have_css "span[class='rounded font-semibold px-3 py-2 text-white bg-red-500']",
                             text: 'canceled'
  end
end
