# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repo::TaxonomyRepo do
  subject { build(:taxonomy_repo) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:repo) }
    it { is_expected.to validate_uniqueness_of(:repo).scoped_to(:taxonomy_id) }
  end
end
