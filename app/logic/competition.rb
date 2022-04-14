# frozen_string_literal: true

module Competition
  extend self

  delegate :list_actual_challenges, to: ChallengesQuery
  delegate :list_taxonomies, to: TaxonomiesQuery
end
