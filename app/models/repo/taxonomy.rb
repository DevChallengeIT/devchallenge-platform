# frozen_string_literal: true

module Repo
  class Taxonomy < ApplicationRecord
    extend FriendlyId
    friendly_id :title, use: :slugged

    has_many :taxons, dependent: :destroy_async

    validates :title, presence: true
    validates :title, uniqueness: { case_sensitive: true }
  end
end
