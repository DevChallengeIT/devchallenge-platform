# frozen_string_literal: true

module Competition
  class ChallengePolicy
    attr_reader :user, :challenge

    def self.can_read?(**args)
      new(**args).can_read?
    end

    def self.can_join?(**args)
      new(**args).can_join?
    end

    def initialize(user:, challenge:)
      @user = user
      @challenge = challenge
    end

    def can_read?
      challenge.ready? || Auth.admin?(user)
    end

    def can_join?
      user && challenge.ready? && !joined?(user, challenge)
    end

    private

    def joined?(user, challenge)
      challenge.members.exists?(user:)
    end
  end
end
