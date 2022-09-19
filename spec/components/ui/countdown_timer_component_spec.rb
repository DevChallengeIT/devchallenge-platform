# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UI::CountdownTimerComponent, type: :component do
  let(:countdown_ms) { 1_663_896_827_934 }

  it 'renders countdown timer' do
    render_inline(described_class.new(id: 1, countdown_ts: Time.zone.at(countdown_ms)))

    expect(page).to have_text "\"countdown-1\", #{countdown_ms}"
  end
end
