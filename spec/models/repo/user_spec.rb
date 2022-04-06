# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repo::User do
  subject { described_class.new }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:full_name) }
  end
end
