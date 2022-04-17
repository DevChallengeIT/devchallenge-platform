# frozen_string_literal: true

module Repo
  class Member < ApplicationRecord
    belongs_to :user
    belongs_to :challenge

    enum role: {
      participant: 'participant',
      judge:       'judge'
    }

    validates :challenge, presence: true
    validates :user, presence: true, uniqueness: { scope:   :challenge,
                                                   message: I18n.t('messages.member_exists') }
  end
end
