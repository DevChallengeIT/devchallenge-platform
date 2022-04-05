# frozen_string_literal: true

module Repo
  class Challenge < ApplicationRecord
    extend FriendlyId
    friendly_id :title, use: :slugged

    DRAFT = 'draft'
    MODERATION = 'moderation'
    PENDING = 'pending'
    REGISTRATION = 'registration'
    LIVE = 'live'
    COMPLETE = 'complete'
    CANCELED = 'canceled'

    STATUSES = [DRAFT, MODERATION, PENDING, REGISTRATION, LIVE, COMPLETE, CANCELED].freeze

    validates :title, presence: true
    validates :slug, presence: true, if: :persisted?
    validates :slug, uniqueness: true, if: :persisted?
    validates :status, inclusion: { in: STATUSES }
  end
end
