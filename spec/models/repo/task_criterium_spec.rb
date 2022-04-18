# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repo::TaskCriterium, type: :model do
  subject { create(:task_criterium) }

  describe 'associations' do
    it { is_expected.to belong_to(:task) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:task) }
    it { is_expected.to validate_presence_of(:max_value) }
    it { is_expected.to validate_numericality_of(:max_value).only_integer }
  end
end
