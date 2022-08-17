# frozen_string_literal: true

module UI
  class ChallengeStatusComponent < ViewComponent::Base
    COLOR_STATUS = {
      'draft'        => 'bg-gray-100 text-gray-800',
      'moderation'   => 'bg-orange-100 text-orange-800',
      'pending'      => 'bg-gray-100 text-gray-800',
      'registration' => 'bg-blue-100 text-blue-800',
      'live'         => 'bg-green-100 text-green-800',
      'completed'    => 'bg-violet-100 text-violet-800',
      'canceled'     => 'bg-red-100 text-red-800'
    }.freeze

    def initialize(challenge:)
      @status = if challenge.status != 'ready'
                  challenge.status
                else
                  use_ready_status(challenge)
                end
    end

    def use_ready_status(challenge)
      if pending?(challenge)
        'pending'
      elsif registration?(challenge)
        'registration'
      elsif live?(challenge)
        'live'
      elsif completed?(challenge)
        'completed'
      end
    end

    def pending?(challenge)
      Time.zone.now < challenge.registration_at
    end

    def registration?(challenge)
      (challenge.registration_at..challenge.start_at).cover?(Time.zone.now)
    end

    def live?(challenge)
      (challenge.start_at..challenge.finish_at).cover?(Time.zone.now)
    end

    def completed?(challenge)
      Time.zone.now > challenge.finish_at
    end

    def status_classes
      COLOR_STATUS[@status]
    end
  end
end
