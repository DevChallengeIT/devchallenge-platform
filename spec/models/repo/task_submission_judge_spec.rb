# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repo::TaskSubmissionJudge, type: :model do
  subject { create(:task_submission_judge) }

  describe 'associations' do
    it { is_expected.to belong_to(:task_submission) }
    it { is_expected.to belong_to(:judge) }
  end
end
