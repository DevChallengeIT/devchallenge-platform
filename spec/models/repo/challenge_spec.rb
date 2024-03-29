# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repo::Challenge do
  subject { build(:challenge) }

  describe 'associations' do
    it { is_expected.to have_many(:taxon_entities) }
    it { is_expected.to have_many(:taxons) }
    it { is_expected.to have_many(:members) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_uniqueness_of(:title).case_insensitive }

    it 'defines enum for status' do
      expect(subject).to define_enum_for(:status).with_values(
        draft:      'draft',
        moderation: 'moderation',
        ready:      'ready',
        canceled:   'canceled',
        completed:  'completed'
      ).backed_by_column_of_type(:enum)
    end
  end

  describe 'callbacks' do
    it 'schedules CreateSubscribersGroupJob' do
      allow(CreateSubscribersGroupJob).to receive(:perform_later).with(challenge: subject)
      subject.save!
      expect(CreateSubscribersGroupJob).to have_received(:perform_later).with(challenge: subject)
    end
  end
end
