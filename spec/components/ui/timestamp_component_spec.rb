# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UI::TimestampComponent, type: :component do
  it 'renders formatted timestamp value' do
    render_inline(described_class.new(data: Time.zone.parse('2022-04-04 18:13:00')))

    expect(rendered_component).to have_text '2022 Apr 04 - 18:13'
  end

  it 'renders nothing if nil value' do
    render_inline(described_class.new(data: nil))

    expect(rendered_component).to have_text ''
  end
end
