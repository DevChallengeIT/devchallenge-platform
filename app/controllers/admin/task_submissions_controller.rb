# frozen_string_literal: true

module Admin
  class TaskSubmissionsController < BaseController
    helper_method :task, :task_submission, :member

    def index
      @paginator, @task_submissions = paginate task.task_submissions
    end

    def destroy
      task_submission.destroy
      redirect_to(admin_task_submissions_path(task), notice: flash_message(:removed, :task_submissions))
    end

    private

    def task_submission
      @task_submission ||= task.task_submissions.find(params[:id])
    end

    def task
      @task ||= Repo::Task.friendly.find(params[:task_id])
    end
  end
end
