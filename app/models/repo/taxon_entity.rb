# frozen_string_literal: true

module Repo
  class TaxonEntity < ApplicationRecord
    belongs_to :taxon
    belongs_to :entity, polymorphic: true

    validates :taxon, uniqueness: { scope: %i[entity_id entity_type] }
  end
end
