# frozen_string_literal: true

module UI
  class TasksController < BaseController
    include CompetitionContext

    before_action :authenticate_user!, :authorize_member!
    helper_method :task, :task_submission

    private

    def challenge
      @challenge ||= task.challenge
    end

    def task
      @task ||= Repo::Task.preload(:challenge, :rich_text_description, :task_submissions).friendly.find(params[:id])
    end

    def task_submission
      @task_submission ||= task.task_submissions.find_by(member: current_member) || Repo::TaskSubmission.new
    end
  end
end
