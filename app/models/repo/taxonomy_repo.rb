# frozen_string_literal: true

module Repo
  class TaxonomyRepo < ApplicationRecord
    belongs_to :taxonomy

    validates :repo, presence: true
    validates :repo, uniqueness: { scope: :taxonomy_id }
  end
end
