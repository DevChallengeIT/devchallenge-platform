# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UI::TimestampComponent, type: :component do
  it 'renders formatted timestamp value' do
    render_inline(described_class.new(data: Time.zone.parse('2022-04-04 18:13:00')))

    expect(page).to have_css 'span',
                             text: '2022 Apr 04 - 18:13'
  end

  it 'renders formatted timestamp value with highlight_now in the past' do
    render_inline(described_class.new(data: 10.days.ago, highlight_now: true))

    expect(page).to have_css "span[class='bg-green-100 text-green-800']"
  end

  it 'renders formatted timestamp value with highlight_now in the future' do
    render_inline(described_class.new(data: 10.days.from_now, highlight_now: true))

    expect(page).to have_css "span[class='bg-gray-100 text-gray-800']"
  end

  it 'renders nothing if nil value' do
    render_inline(described_class.new(data: nil))

    expect(page).to have_text ''
  end
end
