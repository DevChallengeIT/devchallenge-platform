# frozen_string_literal: true

module Competition
  class AssessmentService
    def self.create_assessments(**args)
      new(**args).create
    end

    def self.update_assessments(**args)
      new(**args).update
    end

    attr_reader :submission, :judge, :params

    def initialize(submission:, judge:, params:)
      @submission = submission
      @judge      = judge
      @params     = params
    end

    def create
      insert = params.map do |criteria_id, params|
        {
          value:              params['value'],
          comment:            params['comment'],
          judge_id:           judge.id,
          task_criterium_id:  criteria_id,
          task_submission_id: submission.id,
          created_at:         Time.zone.now,
          updated_at:         Time.zone.now
        }
      end
      Repo::TaskAssessment.insert_all(insert)
    end

    def update
      upsert = params.map do |criteria_id, params|
        {
          value:              params['value'],
          comment:            params['comment'],
          judge_id:           judge.id,
          task_criterium_id:  criteria_id,
          task_submission_id: submission.id,
          created_at:         Time.zone.now,
          updated_at:         Time.zone.now
        }
      end
      Repo::TaskAssessment.upsert_all(upsert, unique_by: :unique_index_for_task_assesments)
    end
  end
end
