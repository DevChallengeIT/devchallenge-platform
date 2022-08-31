# frozen_string_literal: true

module Competition
  class TaskResultsQuery
    def self.task_results(**args)
      new(**args).task_results
    end

    def self.task_sum_results(**args)
      new(**args).task_sum_results
    end

    attr_reader :task

    def initialize(task:)
      @task = task
    end

    # rubocop:disable Metrics/MethodLength
    def task_results
      query = <<-SQL
        SELECT
          ta.id,
          ts.member_id,
          ta.task_criterium_id as criteria_id,
          ta.judge_id,
          ta.value
        FROM
          task_assessments ta
          JOIN task_criteria tc ON tc.id = ta.task_criterium_id
          JOIN tasks t ON t.id = tc.task_id
          JOIN task_submissions ts ON ts.id = ta.task_submission_id
        WHERE
          t.id = #{task.id}
      SQL

      ActiveRecord::Base.connection.execute(query).as_json
    end
    # rubocop:enable Metrics/MethodLength

    # rubocop:disable Metrics/MethodLength
    def task_sum_results
      query = <<-SQL
        SELECT
          ts.member_id,
          u.full_name,
          u.email,
          SUM(ta.value) / COUNT(DISTINCT(ta.judge_id)) as sum
        FROM
          task_assessments ta
          JOIN task_criteria tc ON tc.id = ta.task_criterium_id
          JOIN tasks t ON t.id = tc.task_id
          JOIN task_submissions ts ON ts.id = ta.task_submission_id
          JOIN members m ON m.id = ts.member_id
          JOIN users u ON u.id = m.user_id
          WHERE tc.task_id = #{task.id}
        GROUP BY ts.member_id, u.id
        ORDER BY sum desc
      SQL

      ActiveRecord::Base.connection.execute(query).as_json
    end
    # rubocop:enable Metrics/MethodLength
  end
end
