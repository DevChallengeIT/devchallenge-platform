# frozen_string_literal: true

module UI
  class SubmissionsController < BaseController
    include CompetitionContext

    before_action :authenticate_user!

    def create
      @task_submission = Repo::TaskSubmission.new(task_submission_params)

      if task_submission.save
        Competition.auto_assign_judge(task_submission:)
        redirect_to task_path(task), notice: flash_message(:created, :task_submissions)
      else
        redirect_to task_path(task), status: :unprocessable_entity
      end
    end

    def update
      if task_submission.update(task_submission_params)
        redirect_to task_path(task), notice: flash_message(:updated, :task_submissions)
      else
        redirect_to task_path(task), status: :unprocessable_entity
      end
    end

    def destroy
      task_submission.destroy
      redirect_to task_path(task_submission.task), notice: flash_message(:removed, :task_submissions)
    end

    private

    def task
      @task ||= if params[:task_id]
                  Repo::Task.friendly.find(params[:task_id])
                else
                  task_submission.task
                end
    end

    def challenge
      @challenge ||= task.challenge
    end

    def task_submission
      @task_submission ||= Repo::TaskSubmission.preload(:task, :task_assessments).find(params[:id])
    end

    def task_submission_params
      params.require(:task_submission)
            .permit(:notes, :zip_file)
            .merge(member: current_member, task:)
    end
  end
end
