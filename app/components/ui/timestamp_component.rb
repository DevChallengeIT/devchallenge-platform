# frozen_string_literal: true

module UI
  class TimestampComponent < ViewComponent::Base
    TIME_FORMAT = '%Y %b %d - %H:%M'

    def initialize(data:)
      @data = data
    end

    def render?
      @data.present?
    end
  end
end
