# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UI::ChallengeStatusComponent, type: :component do
  it 'renders draft staus' do
    render_inline(described_class.new(challenge: build(:challenge, status: 'draft')))

    expect(rendered_component).to have_css "span[class='rounded-xl px-3 py-2 text-white bg-gray-500']", text: 'draft'
  end

  it 'renders moderation staus' do
    render_inline(described_class.new(challenge: build(:challenge, status: 'moderation')))

    expect(rendered_component).to have_css "span[class='rounded-xl px-3 py-2 text-white bg-orange-500']",
                                           text: 'moderation'
  end

  it 'renders pending staus' do
    render_inline(described_class.new(challenge: build(:challenge, status: 'pending')))

    expect(rendered_component).to have_css "span[class='rounded-xl px-3 py-2 text-white bg-lime-500']", text: 'pending'
  end

  it 'renders registration staus' do
    render_inline(described_class.new(challenge: build(:challenge, status: 'registration')))

    expect(rendered_component).to have_css "span[class='rounded-xl px-3 py-2 text-white bg-cyan-500']",
                                           text: 'registration'
  end

  it 'renders live staus' do
    render_inline(described_class.new(challenge: build(:challenge, status: 'live')))

    expect(rendered_component).to have_css "span[class='rounded-xl px-3 py-2 text-white bg-green-500']", text: 'live'
  end

  it 'renders complete staus' do
    render_inline(described_class.new(challenge: build(:challenge, status: 'complete')))

    expect(rendered_component).to have_css "span[class='rounded-xl px-3 py-2 text-white bg-indigo-500']",
                                           text: 'complete'
  end

  it 'renders canceled staus' do
    render_inline(described_class.new(challenge: build(:challenge, status: 'canceled')))

    expect(rendered_component).to have_css "span[class='rounded-xl px-3 py-2 text-white bg-red-500']", text: 'canceled'
  end
end
