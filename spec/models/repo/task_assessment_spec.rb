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
end
