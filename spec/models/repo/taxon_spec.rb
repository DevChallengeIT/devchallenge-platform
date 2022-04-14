# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repo::Taxon do
  subject { build(:taxon) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_uniqueness_of(:title).case_insensitive }
  end
end
