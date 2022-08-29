# frozen_string_literal: true

module UI
  class TimestampComponent < ViewComponent::Base
    TIME_FORMAT = '%Y %b %d - %H:%M'
    HIGHLIGHT_BG = {
      true  => 'bg-green-100 text-green-800',
      false => 'bg-gray-100 text-gray-800'
    }.freeze

    def initialize(data:, highlight_now: false)
      @data = data
      @highlight_now = highlight_now
    end

    def render?
      @data.present?
    end

    def highlight_classes
      return unless @highlight_now

      HIGHLIGHT_BG[Time.zone.now > @data]
    end
  end
end
