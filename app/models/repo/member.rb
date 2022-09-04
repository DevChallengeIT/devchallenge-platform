# frozen_string_literal: true

module Repo
  class Member < ApplicationRecord
    belongs_to :user
    belongs_to :challenge

    has_many :task_submissions, dependent: :destroy

    enum role: {
      participant: 'participant',
      judge:       'judge'
    }

    validates :challenge, presence: true
    validates :user, presence: true, uniqueness: { scope:   :challenge,
                                                   message: I18n.t('messages.member_exists') }

    after_create do
      CreateGroupSubscriberJob.perform_later(member: self)
    end

    before_destroy do
      RemoveGroupSubscriberJob.perform_later(email: user.email, group_id: challenge.remote_email_group_id)
    end
  end
end
