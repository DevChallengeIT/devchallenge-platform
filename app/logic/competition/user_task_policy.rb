# frozen_string_literal: true

module Competition
  class UserTaskPolicy
    def self.can_user_do_task?(**params)
      new(**params).can_do?
    end

    attr_reader :user, :task

    delegate :admin?, to: Auth
    delegate :judge?, :participant?, to: :member, allow_nil: true

    def initialize(user:, task:)
      @user = user
      @task = task
    end

    def can_do?
      return true if admin?(user) || judge?

      participant? && dependent_assessed_enough?
    end

    private

    def member
      @member ||= task.challenge.members.find { |m| m.user_id == @user&.id }
    end

    def dependent_assessed_enough?
      return true if dependent_task.blank?

      current_assessment_value >= (task&.min_assessment || 0)
    end

    def dependent_task
      @dependent_task ||= task.dependent_task
    end

    def current_assessment_value
      @current_assessment_value ||= TasksAssessmentCalculator.total_assessment_for(
        participant: member,
        task:        dependent_task
      )
    end
  end
end
