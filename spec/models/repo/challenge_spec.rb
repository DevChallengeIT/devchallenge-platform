# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repo::Challenge do
  subject { described_class.new }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_inclusion_of(:status).in_array(Repo::Challenge::STATUSES) }
  end
end
