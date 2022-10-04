# frozen_string_literal: true

module Admin
  class TaskJudgesController < BaseController
    helper_method :challenge, :task, :potential_judges, :task_submission

    add_breadcrumb I18n.t('resources.challenges.plural'), :admin_challenges_path
    add_breadcrumb(proc { |ctx| ctx.challenge.title }, proc { |ctx| ctx.admin_challenges_path(ctx.challenge) })
    add_breadcrumb I18n.t('resources.tasks.plural'), :admin_challenge_tasks_path
    add_breadcrumb(proc { |ctx| ctx.task.title }, proc { |ctx|
                                                    ctx.edit_admin_challenge_task_path(ctx.challenge, ctx.task)
                                                  })
    add_breadcrumb I18n.t('resources.judges.plural')

    # TODO
    def create
      Repo::TaskSubmissionJudge.create(task_submission:, judge_id: params[:judge_id])
      redirect_to admin_challenge_task_submission_judges_path(challenge, task, task_submission)
    end

    # TODO
    def destroy
      submission_judge = Repo::TaskSubmissionJudge.find(params[:id])
      submission_judge.destroy
      redirect_to admin_challenge_task_submission_judges_path(challenge, task, task_submission)
    end

    private

    def task
      @task ||= Repo::Task.preload(:challenge).friendly.find(params[:task_id])
    end

    def task_submission
      @task_submission ||= Repo::TaskSubmission
                           .preload(task_submission_judges: [judge: :user])
                           .find(params[:submission_id])
    end

    def challenge
      @challenge ||= task.challenge
    end

    def potential_judges
      @potential_judges ||= challenge
                            .members
                            .judge
                            .preload(:user)
                            .where.not(id: task_submission.judge_ids << task_submission.judge_id)
    end
  end
end
