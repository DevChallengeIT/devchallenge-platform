# frozen_string_literal: true

module Competition
  class ChallengesQuery
    include ActiveRecord::Sanitization::ClassMethods

    def self.list_actual_challenges(**params)
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
      scope = maybe_filter_by_taxons(scope, filter)
      scope.distinct
    end

    private

    def base_scope
      Repo::Challenge.where(status: :ready)
    end

    def maybe_search(scope)
      return scope if search.blank?

      scope.where('challenges.title LIKE ?', "%#{sanitize_sql_like(search)}%")
    end

    def maybe_filter_by_taxons(scope, _filter)
      return scope if filter_taxon_ids.blank?

      scope
        .includes(taxon_entities: :taxon)
        .where(taxon_entities: { taxons: { id: filter_taxon_ids } })
    end

    def filter_taxon_ids
      @filter_taxon_ids ||= filter[:taxon_ids] || []
    end
  end
end
