# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repo::TaxonEntity do
  subject { described_class.new }

  describe 'associations' do
    it { is_expected.to belong_to(:taxon) }
    it { is_expected.to belong_to(:entity) }
  end
end
