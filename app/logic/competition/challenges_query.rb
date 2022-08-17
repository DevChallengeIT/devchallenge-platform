# frozen_string_literal: true

module Competition
  class ChallengesQuery
    include ActiveRecord::Sanitization::ClassMethods

    def self.list_challenges(**params)
      new(**params).call
    end

    attr_reader :search, :filter

    def initialize(search: nil, filter: {})
      @search = search
      @filter = filter
    end

    def call
      scope = base_scope
      scope = maybe_search(scope)
      scope = maybe_filter_by_status(scope, filter[:status_in])
      scope = maybe_filter_by_taxons(scope, filter[:taxon_ids])
      scope.distinct
    end

    private

    def base_scope
      Repo::Challenge.preload(:rich_text_description)
    end

    def maybe_search(scope)
      return scope if search.blank?

      scope.where('challenges.title LIKE ?', "%#{sanitize_sql_like(search)}%")
    end

    def maybe_filter_by_status(scope, statuses)
      return scope if statuses.blank?

      scope.where(status: statuses)
    end

    def maybe_filter_by_taxons(scope, taxon_ids)
      return scope if taxon_ids.blank?

      scope
        .includes(taxon_entities: :taxon)
        .where(taxon_entities: { taxons: { id: taxon_ids } })
    end
  end
end
