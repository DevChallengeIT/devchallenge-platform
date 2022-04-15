# frozen_string_literal: true

module UI
  class ChallengesController < BaseController
    helper_method :challenge, :filter_taxon_ids

    def index
      @taxonomies = Competition.list_taxonomies(repo: :challenges).load_async
      @paginator, @challenges = paginate(
        Competition.list_challenges(search:, filter: filter.merge(status_in: [:ready])).load_async
      )
    end

    private

    def challenge
      @challenge ||= Repo::Challenge.friendly.find(params[:id])
    end

    def search
      @search ||= params[:search]
    end

    def filter
      @filter ||= params[:filter] || {}
    end

    def filter_taxon_ids
      @filter_taxon_ids ||= filter[:taxon_ids] || []
    end
  end
end
