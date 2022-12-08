# frozen_string_literal: true

module UI
  class ChallengesController < BaseController
    include CompetitionContext

    helper_method :filter_taxon_ids, :filter_status_in

    def index
      @taxonomies = Competition.list_taxonomies(repo: :challenges).load_async
      @paginator, @challenges = paginate(
        Competition.list_challenges(search:, filter: apply_filter).load_async
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

    def filter_status_in
      @filter_status_in ||= filter[:status_in] || []
    end

    def filter_taxon_ids
      @filter_taxon_ids ||= filter[:taxon_ids] || []
    end

    def apply_filter
      @apply_filter ||= if filter_status_in.empty?
                          filter.merge(status_in: [:ready])
                        else
                          filter
                        end
    end
  end
end
