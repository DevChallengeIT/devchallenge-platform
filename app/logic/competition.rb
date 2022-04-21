# frozen_string_literal: true

module Competition
  extend self

  delegate :list_challenges, to: ChallengesQuery
  delegate :list_taxonomies, to: TaxonomiesQuery
  delegate :can_read?,       to: ChallengePolicy
  delegate :can_join?,       to: ChallengePolicy
end
