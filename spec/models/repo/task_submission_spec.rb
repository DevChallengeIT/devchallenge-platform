# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repo::TaskSubmission, type: :model do
  subject { create(:task_submission) }

  describe 'associations' do
    it { is_expected.to belong_to(:member) }
    it { is_expected.to belong_to(:task) }
    it { is_expected.to belong_to(:judge).optional }
    it { is_expected.to have_many(:task_assessments) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:member) }
    it { is_expected.to validate_presence_of(:task) }
    it { is_expected.to validate_uniqueness_of(:task).scoped_to(:member_id) }
  end
end
