# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repo::Challenge do
  subject { build(:challenge) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_uniqueness_of(:title).case_insensitive }

    it 'defines enum for status' do
      expect(subject).to define_enum_for(:status).with_values(
        draft:        'draft',
        moderation:   'moderation',
        pending:      'pending',
        registration: 'registration',
        live:         'live',
        complete:     'complete',
        canceled:     'canceled'
      ).backed_by_column_of_type(:enum)
    end
  end
end
