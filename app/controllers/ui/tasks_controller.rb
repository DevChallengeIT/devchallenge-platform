# frozen_string_literal: true

module UI
  class TasksController < BaseController
    include CompetitionContext

    before_action :authenticate_user!, :authorize_member!
    helper_method :task, :task_submission, :task_submissions

    def show
      if current_member&.judge?
        @paginator, @task_submissions = paginate task_submissions
        render 'ui/tasks/judges/show'
      else
        super
      end
    end

    private

    def challenge
      @challenge ||= task.challenge
    end

    def task
      @task ||= Repo::Task.preload(
        :challenge,
        :rich_text_description,
        :task_submissions
      ).friendly.find(params[:id])
    end

    def task_submission
      @task_submission ||= task.task_submissions.find_by(member: current_member) || Repo::TaskSubmission.new
    end

    def task_submissions
      @task_submissions ||= task.task_submissions.preload(:task_assessments)
    end
  end
end
