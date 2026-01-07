# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repo::Member do
  subject { build(:member) }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:challenge) }
    it { is_expected.to have_many(:task_submissions) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:challenge) }
  end

  describe 'callbacks' do
    it 'schedules CreateGroupSubscriberJob' do
      allow(CreateGroupSubscriberJob).to receive(:perform_later).with(member: subject)
      allow(CreateSendpulseMemberJob).to receive(:perform_later).with(member: subject)
      subject.save!
      expect(CreateGroupSubscriberJob).to have_received(:perform_later).with(member: subject)
    end

    it 'schedules CreateSendpulseMemberJob' do
      allow(CreateGroupSubscriberJob).to receive(:perform_later).with(member: subject)
      allow(CreateSendpulseMemberJob).to receive(:perform_later).with(member: subject)
      subject.save!
      expect(CreateSendpulseMemberJob).to have_received(:perform_later).with(member: subject)
    end

    it 'schedules RemoveGroupSubscriberJob' do
      allow(CreateSendpulseMemberJob).to receive(:perform_later).with(member: subject)
      subject.save!

      allow(RemoveGroupSubscriberJob).to receive(:perform_later).with(email: subject.user.email, group_id: subject.challenge.remote_email_group_id)
      allow(RemoveSendpulseMemberJob).to receive(:perform_later)
      subject.destroy!
      expect(RemoveGroupSubscriberJob).to have_received(:perform_later).with(email: subject.user.email, group_id: subject.challenge.remote_email_group_id)
    end

    it 'schedules RemoveSendpulseMemberJob' do
      allow(CreateSendpulseMemberJob).to receive(:perform_later).with(member: subject)
      subject.save!

      allow(RemoveGroupSubscriberJob).to receive(:perform_later)
      allow(RemoveSendpulseMemberJob).to receive(:perform_later).with(
        email:     subject.user.email,
        phone:     subject.user.phone_number.presence || '',
        challenge: subject.challenge.title,
        fullname:  subject.user.full_name
      )
      subject.destroy!
      expect(RemoveSendpulseMemberJob).to have_received(:perform_later).with(
        email:     subject.user.email,
        phone:     subject.user.phone_number.presence || '',
        challenge: subject.challenge.title,
        fullname:  subject.user.full_name
      )
    end
  end
end
