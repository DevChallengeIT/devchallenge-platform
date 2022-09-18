# frozen_string_literal: true

module UI
  class AssessmentsController < BaseController
    include CompetitionContext

    helper_method :task, :task_submission, :task_criteria, :task_assessments

    before_action :authenticate_user!
    before_action :authorize_judge!

    def create
      Competition.create_assessments(
        submission: task_submission,
        judge:      current_member,
        params:     params['assesment'].to_unsafe_hash
      )
      redirect_to task_path(task), notice: flash_message(:created, :task_assessments)
    end

    def edit
      @assesments = task_submission.task_assessments.by_judge(current_member).each_with_object({}) do |assesment, acum|
        acum[assesment.task_criterium_id] = {
          value:   assesment.value,
          comment: assesment.comment
        }
      end
    end

    def update
      Competition.update_assessments(
        submission: task_submission,
        judge:      current_member,
        params:     params['assesment'].to_unsafe_hash
      )
      redirect_to task_path(task), notice: flash_message(:updated, :task_assessments)
    end

    private

    def task
      @task ||= task_submission.task
    end

    def task_criteria
      @task_criteria ||= task.task_criteria
    end

    def task_assessments
      @task_assessments ||= task_submission.task_assessments
    end

    def challenge
      @challenge ||= task.challenge
    end

    def task_submission
      @task_submission ||= Repo::TaskSubmission.preload(
        :zip_file_blob,
        task:             %i[challenge rich_text_description task_criteria],
        task_assessments: :task_criterium
      ).find(params[:submission_id])
    end
  end
end
