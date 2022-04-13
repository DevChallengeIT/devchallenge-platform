# frozen_string_literal: true

module UI
  class ChallengeStatusComponent < ViewComponent::Base
    COLOR_STATUS = {
      Repo::Challenge.statuses['draft']      => 'bg-gray-500',
      Repo::Challenge.statuses['moderation'] => 'bg-orange-500',
      Repo::Challenge.statuses['ready']      => 'bg-green-500',
      Repo::Challenge.statuses['canceled']   => 'bg-red-500'
    }.freeze

    def initialize(challenge:)
      @status = challenge.status
    end

    def status_classes
      COLOR_STATUS[@status]
    end
  end
end
