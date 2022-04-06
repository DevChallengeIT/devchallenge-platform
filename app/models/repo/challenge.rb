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
  end
end
