# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Auth do
  describe '.admin?' do
    it 'returns true for admin user' do
      user = create(:user, :admin)

      expect(described_class.admin?(user)).to eq true
    end

    it 'reutrns fallse for regular user' do
      user = create(:user)

      expect(described_class.admin?(user)).to eq false
    end

    it 'reutrns fallse for nil user' do
      expect(described_class.admin?(nil)).to eq false
    end
  end

  describe 'omniauth' do
    subject { described_class.omniauth(auth) }

    let(:info) { double(name: 'Tester', email: 'tester@exmaple.com') }
    let(:auth) { double(:auth, provider: 'github', uid: '54786', info:) }

    context 'when new user' do
      it 'creates a new user reocrd' do
        expect { subject }.to change(Repo::User, :count).by(1)
      end

      it 'returns newwly created user record' do
        expect(subject.email).to eq info.email
        expect(subject.full_name).to eq info.name
        expect(subject.provider).to eq auth.provider
        expect(subject.uid).to eq auth.uid
      end
    end

    context 'when existing user' do
      before { create(:user, email: info.email) }

      it 'does not create a new user record' do
        expect { subject }.to change(Repo::User, :count).by(0)
      end

      it 'returns errors' do
        expect(subject.errors.messages).to eq({ email: ['has already been taken'] })
      end
    end

    context 'when legacy user' do
      before { create(:user, email: info.email, legacy_id: '333') }

      it 'does not create a new user record' do
        expect { subject }.to change(Repo::User, :count).by(0)
      end

      it 'allow to use existing record and update it provider/uid' do
        expect(subject.email).to eq info.email
        expect(subject.full_name).to eq info.name
        expect(subject.provider).to eq auth.provider
        expect(subject.uid).to eq auth.uid
        expect(subject.legacy_id).to eq '333'
      end
    end
  end
end
