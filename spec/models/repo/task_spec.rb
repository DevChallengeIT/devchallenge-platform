# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repo::Task, type: :model do
  subject { create(:task) }

  describe 'associations' do
    it { is_expected.to belong_to(:challenge) }
    it { is_expected.to belong_to(:dependent_task).optional }
    it { is_expected.to have_many(:task_submissions) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_uniqueness_of(:title).scoped_to(:challenge_id).case_insensitive }
  end
end
