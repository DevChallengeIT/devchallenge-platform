# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Auth do
  describe '.admin?' do
    it 'reutrns true for admin user' do
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
end
