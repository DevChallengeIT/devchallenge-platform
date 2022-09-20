# frozen_string_literal: true

module Admin
  class DashboardController < BaseController
    helper_method :members_by_challenge_per_day

    def members_by_challenge_per_day
      Repo::Member
        .joins(:challenge)
        .where(created_at: 1.month.ago..)
        .group('challenges.title')
        .group_by_day(:created_at)
        .count
        .each_with_object({}) do |(key, value), acc|
          scope, _day = key
          last_value = acc.filter { |k, _v| k[0] == scope }&.max&.dig(1) || 0
          acc[key] = (last_value + value)
        end
    end
  end
end
