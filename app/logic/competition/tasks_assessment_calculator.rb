# frozen_string_literal: true

module Competition
  class TasksAssessmentCalculator
    def self.total_assessment_for(**params)
      new(**params).total_assessment
    end

    attr_reader :participant, :task

    def initialize(participant:, task:)
      @participant = participant
      @task = task
    end

    def total_assessment
      task.task_submissions.joins(:task_assessments).where(task_submissions: { member: participant }).sum(:value) || 0
    end
  end
end
