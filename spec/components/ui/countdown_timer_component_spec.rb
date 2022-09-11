# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UI::CountdownTimerComponent, type: :component do
  it 'renders countdown timer' do
    render_inline(described_class.new(id: 1, countdown_ts: Time.zone.now + 9.days + 4.hours + 21.minutes + 54.seconds + 0.999))

    # 793314000ms is equal '9d 4h 21m 54s'
    # omitting msec ending because it is spent on running code
    expect(page).to have_text '"countdown-1", 793314'
  end
end
