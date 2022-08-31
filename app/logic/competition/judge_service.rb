# frozen_string_literal: true

module Competition
  class JudgeService
    def self.auto_assign_judge(**args)
      new(**args).auto_assign_judge
    end

    attr_reader :task_submission

    def initialize(task_submission:)
      @task_submission = task_submission
    end

    def auto_assign_judge
      task_submission.update(judge_id: next_judge&.id)
    end

    def next_judge
      challenge_judges[task_submissiouns_count - 1]
    end

    def challenge_judges
      @challenge_judges ||= CircularArray.new(task_submission.task.challenge.members.judge.order(:id))
    end

    def task_submissiouns_count
      @task_submissiouns_count ||= task_submission.task.task_submissions.count
    end
  end
end
