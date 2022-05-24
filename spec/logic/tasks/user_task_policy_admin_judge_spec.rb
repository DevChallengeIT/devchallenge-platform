# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tasks::UserTaskPolicy do
  subject(:policy) { Tasks.can_user_do_task?(user:, task:) }

  let(:user) { create(:user) }
  let(:task) { create(:task) }

  context 'when just a random user' do
    it { expect(policy).to be_falsey }
  end

  context 'when user is an admin' do
    let(:user) { create(:user, :admin) }

    it { expect(policy).to be true }
  end

  context 'when a user is a judge' do
    let(:user) { judge.user }
    let(:task) { create(:task, challenge: judge.challenge) }
    let(:judge) { create(:member, :judge) }

    it { expect(policy).to be true }
  end
end
