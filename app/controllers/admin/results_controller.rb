# frozen_string_literal: true

module Admin
  class ResultsController < BaseController
    helper_method :task, :challenge, :judges_count

    add_breadcrumb I18n.t('resources.challenges.plural'), :admin_challenges_path
    add_breadcrumb(proc { |ctx| ctx.challenge.title }, proc { |ctx| ctx.admin_challenges_path(ctx.challenge) })
    add_breadcrumb I18n.t('resources.tasks.plural'), :admin_challenge_tasks_path
    add_breadcrumb(proc { |ctx| ctx.task.title }, proc { |ctx|
                                                    ctx.edit_admin_challenge_task_path(ctx.challenge, ctx.task)
                                                  })
    add_breadcrumb I18n.t('words.results'), :admin_challenge_task_results_path

    def show
      @calc = Competition.task_results_calculator(task:)
      @members = Competition.task_sum_results(task:)
      @criteria = task.task_criteria
      @judges = challenge.members.judge.preload(:user)
    end

    private

    def task
      @task ||= Repo::Task.preload(:challenge, :task_criteria).friendly.find(params[:task_id])
    end

    def challenge
      @challenge ||= task.challenge
    end

    def judges_count
      @judges_count ||= @judges.count
    end
  end
end
