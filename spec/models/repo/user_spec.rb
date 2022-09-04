# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repo::User do
  subject { build(:user) }

  describe 'associations' do
    it { is_expected.to have_many(:taxon_entities) }
    it { is_expected.to have_many(:taxons) }
    it { is_expected.to have_many(:members) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:full_name) }
  end

  describe 'callbacks' do
    it 'schedules  CreateSubscriberJob' do
      allow(CreateSubscriberJob).to receive(:perform_later).with(user: subject)
      subject.save!
      expect(CreateSubscriberJob).to have_received(:perform_later).with(user: subject)
    end
  end
end
