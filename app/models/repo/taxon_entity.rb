# frozen_string_literal: true

module Repo
  class TaxonEntity < ApplicationRecord
    belongs_to :taxon
    belongs_to :entity, polymorphic: true
  end
end
