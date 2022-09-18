# frozen_string_literal: true

module UI
  class CountdownTimerComponent < ViewComponent::Base
    def initialize(id:, countdown_ts: 0)
      @id = "countdown-#{id}"
      @countdown_ms = countdown_in_mseconds(countdown_ts)
    end

    def render?
      false
    end

    def countdown_in_mseconds(countdown_ts)
      (countdown_ts.to_f * 1000.0).to_i
    end
  end
end
