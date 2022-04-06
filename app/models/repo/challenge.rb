# frozen_string_literal: true

module Repo
  class Challenge < ApplicationRecord
    extend FriendlyId
    friendly_id :title, use: :slugged

    enum status: {
      draft:        'draft',
      moderation:   'moderation',
      pending:      'pending',
      registration: 'registration',
      live:         'live',
      complete:     'complete',
      canceled:     'canceled'
    }

    validates :title, presence: true
    validates :slug, presence: true, if: :persisted?
    validates :slug, uniqueness: true, if: :persisted?

    validates :registration_at, comparison: { less_than: :start_at }, allow_nil: true, if: :start_at
    validates :start_at, comparison: { less_than: :finish_at }, allow_nil: true, if: :finish_at
    validates :finish_at, comparison: { greater_than: :start_at }, allow_nil: true, if: :start_at
  end
end
