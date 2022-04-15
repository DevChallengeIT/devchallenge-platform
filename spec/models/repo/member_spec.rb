# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repo::Member do
  subject { build(:member) }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:challenge) }
  end
end
