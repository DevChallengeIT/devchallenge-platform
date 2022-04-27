# frozen_string_literal: true

module Competition
  class ChallengePolicy
    def self.can_read?(**args)
      new(**args).can_read?
    end

    def self.can_join?(**args)
      new(**args).can_join?
    end

    def self.can_leave?(**args)
      new(**args).can_leave?
    end

    def self.registration_opened?(**args)
      new(**args).registration_opened?
    end

    def self.registration_closed?(**args)
      new(**args).registration_closed?
    end

    def self.registration_not_started?(**args)
      new(**args).registration_not_started?
    end

    def initialize(user:, challenge:)
      @user = user
      @challenge = challenge
      @challenge_registration_date = challenge.registration_at.to_datetime
      @challenge_start_date = challenge.start_at.to_datetime
      @challenge_finish_date = challenge.finish_at.to_datetime
    end

    def can_read?
      challenge.ready? || Auth.admin?(user)
    end

    def can_join?
      user && challenge.ready? && !joined? && registration_opened?
    end

    def can_leave?
      user && challenge.ready? && joined? && leave_possible?
    end

    def registration_opened?
      (challenge_registration_date..challenge_start_date).cover?(Time.zone.now)
    end

    def registration_closed?
      challenge_start_date < Time.zone.now
    end

    def registration_not_started?
      Time.zone.now < challenge_registration_date
    end

    private

    attr_reader :user, :challenge, :challenge_registration_date, :challenge_start_date, :challenge_finish_date

    def joined?
      challenge.members.exists?(user:)
    end

    def leave_possible?
      (challenge_registration_date..challenge_finish_date).cover?(Time.zone.now)
    end
  end
end
