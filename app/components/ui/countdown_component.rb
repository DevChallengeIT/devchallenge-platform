# frozen_string_literal: true

module UI
  class CountdownComponent < ViewComponent::Base
    def initialize(timestamp:)
      @timestamp = timestamp
    end

    def render?
      @timestamp.present?
    end
  end
end
