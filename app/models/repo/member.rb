# frozen_string_literal: true

module Repo
  class Member < ApplicationRecord
    belongs_to :user
    belongs_to :challenge

    enum role: {
      participant: 'participant',
      judge:       'judge'
    }

    validates :user, presence: true
    validates :challenge, presence: true
    validates :user, uniqueness: { scope:   %i[challenge role],
                                   message: I18n.t('messages.participant_exists') },
                     if:         :participant?
    validates :user, uniqueness: { scope:   %i[challenge role],
                                   message: I18n.t('messages.judge_exists') },
                     if:         :judge?
  end
end
