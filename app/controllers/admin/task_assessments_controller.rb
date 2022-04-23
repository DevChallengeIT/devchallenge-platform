# frozen_string_literal: true

module Admin
  class TaskAssessmentsController < BaseController
    helper_method :task, :task_assessment, :challenge, :task_submission

    def new
      @task_assessment = Repo::TaskAssessment.new
    end

    def create
      @task_assessment = Repo::TaskAssessment.new(new_task_assessment_params)

      if task_assessment.save
        redirect_to(admin_challenge_task_submissions_path(challenge, task),
                    notice: flash_message(:created, :task_assessments))
      else
        render :new, status: :unprocessable_entity
      end
    end

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

    def task_submission
      @task_submission ||= Repo::TaskSubmission.find(params[:task_submission_id])
    end

    def new_task_assessment_params
      task_assessment_params.merge(
        {
          member:          challenge.members.find_by(user: current_user),
          task_submission:,
          task_criterium:  Repo::TaskCriterium.where(task:).first # TODO: change it after assoc clarification!
        }
      )
    end

    def task_assessment_params
      params.require(:task_assessment).permit(
        :comment, :value
      )
    end
  end
end
