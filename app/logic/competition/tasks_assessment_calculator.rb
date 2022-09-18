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
      return 0 unless participant

      query = <<-SQL
        SELECT
          SUM(ta.value) / COUNT(DISTINCT(ta.judge_id)) as total_assessment
        FROM
          task_assessments ta
        JOIN task_criteria tc ON tc.id = ta.task_criterium_id
        JOIN tasks t ON t.id = tc.task_id
        JOIN task_submissions ts ON ts.task_id = t.id
        JOIN challenges c ON c.id = t.challenge_id
        WHERE t.id = #{task.id} AND ts.member_id = #{participant.id}
      SQL

      ActiveRecord::Base.connection.execute(query).as_json.dig(0, 'total_assessment') || 0
    end
  end
end
