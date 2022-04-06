# frozen_string_literal: true

module Repo
  class Taxon < ApplicationRecord
    extend FriendlyId
    friendly_id :title, use: :slugged

    belongs_to :taxonomy

    validates :title, presence: true
    validates :title, uniqueness: { case_sensitive: true }
  end
end
