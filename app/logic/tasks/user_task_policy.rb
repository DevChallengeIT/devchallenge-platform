# frozen_string_literal: true

module Tasks
  class UserTaskPolicy
    def self.can_user_do_task?(**params)
      new(**params).can_do?
    end

    attr_reader :user, :task

    def initialize(user:, task:)
      @user = user
      @task = task
    end

    def can_do?
      member? && task_started? && assessed_enough?
    end

    private

    def member?
      task.challenge.members.exists?(user:)
    end

    def task_started?
      Time.now.utc > task.start_at
    end

    def assessed_enough?
      return true if dependent_task.blank?

      current_assessment >= dependent_task.min_assessment
    end

    def dependent_task
      @dependent_task ||= task.dependent_task
    end

    def current_assessment
      Tasks::AssessmentCalculator.total_assessment_for(member: user, task:)
    end
  end
end
