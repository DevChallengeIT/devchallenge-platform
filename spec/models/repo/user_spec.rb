# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repo::User do
  subject { build(:user) }

  describe 'associations' do
    it { is_expected.to have_many(:taxon_entities) }
    it { is_expected.to have_many(:taxons) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:full_name) }
  end
end
