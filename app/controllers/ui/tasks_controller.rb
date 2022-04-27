# frozen_string_literal: true

module UI
  class TasksController < BaseController
    include CompetitionContext

    before_action :authenticate_user!, :authorize_member!
    helper_method :task

    private

    def challenge
      @challenge ||= task.challenge
    end

    def task
      @task ||= Repo::Task.friendly.find(params[:id])
    end
  end
end
