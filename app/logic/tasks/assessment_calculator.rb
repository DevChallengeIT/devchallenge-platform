# frozen_string_literal: true

module Tasks
  class AssessmentCalculator
    def self.total_assessment_for(**params)
      new(**params).total_assessment
    end

    attr_reader :member, :task

    def initialize(member:, task:)
      @member = member
      @task   = task
    end

    # TODO: check this
    def total_assessment
      task.task_assessments.where(member:).sum(:value)
    end
  end
end
