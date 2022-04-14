# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repo::TaxonEntity do
  subject { build(:taxon_entity) }

  describe 'associations' do
    it { is_expected.to belong_to(:taxon) }
    it { is_expected.to belong_to(:entity) }
  end

  describe 'validations' do
    it { is_expected.to validate_uniqueness_of(:taxon).scoped_to(:entity_id, :entity_type) }
  end
end
