# frozen_string_literal: true

module UI
  class TasksController < BaseController
    include CompetitionContext

    before_action :authenticate_user!, :authorize_member!
    before_action :authorize_member_for_task!, only: :show
    helper_method :task, :task_submission, :task_submissions

    def show
      if current_member&.judge?
        render 'ui/tasks/judges/show'
      else
        @result = Competition::TasksAssessmentCalculator.total_assessment_for(
          participant: current_member,
          task:
        )

        super
      end
    end

    private

    def authorize_member_for_task!
      return true if user_authorized_for_task?(task)

      redirect_to root_path, alert: t('messages.access_denied')
    end

    def challenge
      @challenge ||= task&.challenge
    end

    def task
      @task ||= Repo::Task.preload(
        :rich_text_description,
        :task_submissions,
        :dependent_task,
        :dependency,
        challenge: :members
      ).friendly.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      nil
    end

    def task_submission
      @task_submission ||= task.task_submissions.find_by(member: current_member) || Repo::TaskSubmission.new
    end

    def task_submissions
      @task_submissions ||= task.task_submissions.preload(:task_assessments)
    end
  end
end
