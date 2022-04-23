# frozen_string_literal: true

module Admin
  class TaskAssessmentsController < BaseController
    helper_method :task, :task_assessment, :challenge

    def edit; end

    def update
      if task_assessment.update(task_assessment_params)
        redirect_to(admin_challenge_task_submissions_path, notice: flash_message(:updated, :task_assessments))
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      task_assessment.destroy
      redirect_to(admin_challenge_task_submissions_path,
                  notice: flash_message(:removed, :task_submissions))
    end

    private

    def challenge
      @challenge ||= task.challenge
    end

    def task_assessment
      @task_assessment ||= task.task_assessments.find(params[:id])
    end

    def task
      @task ||= Repo::Task.friendly.preload(:challenge).find(params[:task_id])
    end

    def task_assessment_params
      params.require(:task_assessment).permit(
        :comment, :value
      )
    end
  end
end
