# frozen_string_literal: true

module UI
  class ChallengesController < BaseController
    include CompetitionContext

    helper_method :filter_taxon_ids, :challenge_task_step

    def index
      @taxonomies = Competition.list_taxonomies(repo: :challenges).load_async
      @paginator, @challenges = paginate(
        Competition.list_challenges(search:, filter: filter.merge(status_in: [:ready])).load_async
      )
    end

    def show
      @tasks = challenge.tasks.includes(:dependent_task, challenge: :members).order(:start_at)
    end

    private

    def search
      @search ||= params[:search]
    end

    def filter
      @filter ||= params[:filter] || {}
    end

    def filter_taxon_ids
      @filter_taxon_ids ||= filter[:taxon_ids] || []
    end

    def challenge_task_step(task, idx)
      [UI::STEP_POINT_ACTIVE, UI::STEP_POINT_DISABLED].sample
    end
  end
end
