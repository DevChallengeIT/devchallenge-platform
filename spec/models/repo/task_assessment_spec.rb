# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repo::TaskAssessment, type: :model do
  subject { create(:task_assessment) }

  describe 'associations' do
    it { is_expected.to belong_to(:judge) }
    it { is_expected.to belong_to(:task_submission) }
    it { is_expected.to belong_to(:task_criterium) }

    it { is_expected.to have_one(:task).through(:task_submission) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:judge) }
    it { is_expected.to validate_presence_of(:task_submission) }
    it { is_expected.to validate_presence_of(:task_criterium) }
    it { is_expected.to validate_uniqueness_of(:task_submission).scoped_to(:task_criterium_id) }
  end
end
