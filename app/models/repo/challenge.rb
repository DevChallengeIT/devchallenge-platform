# frozen_string_literal: true

module Repo
  class Challenge < ApplicationRecord
    extend FriendlyId
    friendly_id :title, use: :slugged

    has_many :tasks, dependent: :destroy

    has_rich_text :description
    has_rich_text :terms_and_conditions

    enum status: {
      draft:      'draft',
      moderation: 'moderation',
      ready:      'ready',
      canceled:   'canceled',
      completed:  'completed'
    }

    belongs_to :vendor, optional: true

    has_many :taxon_entities, as: :entity, dependent: :destroy_async
    has_many :taxons, through: :taxon_entities
    has_many :members, dependent: :destroy_async

    validates :title, presence: true
    validates :title, uniqueness: { case_sensitive: true }
    validates :slug, presence: true, if: :persisted?
    validates :slug, uniqueness: true, if: :persisted?

    validates :registration_at, comparison: { less_than: :start_at }, allow_nil: true, if: :start_at
    validates :start_at, comparison: { less_than: :finish_at }, allow_nil: true, if: :finish_at
    validates :finish_at, comparison: { greater_than: :start_at }, allow_nil: true, if: :start_at

    after_create do
      CreateSubscribersGroupJob.perform_later(challenge: self)
    end
  end
end
