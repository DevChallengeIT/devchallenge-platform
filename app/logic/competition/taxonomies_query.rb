# frozen_string_literal: true

module Competition
  class TaxonomiesQuery
    def self.list_taxonomies(repo:)
      Repo::Taxonomy
        .includes(:taxons, :taxonomy_repos)
        .where(taxonomy_repos: { repo: })
        .distinct
    end
  end
end
