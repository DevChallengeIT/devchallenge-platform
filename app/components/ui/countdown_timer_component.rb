# frozen_string_literal: true

module UI
  class CountdownTimerComponent < ViewComponent::Base
    def initialize(id:, countdown_ts: 0)
      @id = "countdown-#{id}"
      @milliseconds_left = calculate_milliseconds_left(countdown_ts)
    end

    def calculate_milliseconds_left(countdown_ts)
      ((countdown_ts - Time.now.utc) * 1000.0).to_i
    end
  end
end
