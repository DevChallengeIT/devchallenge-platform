# frozen_string_literal: true

module Repo
  class Member < ApplicationRecord
    belongs_to :user
    belongs_to :challenge

    enum role: {
      participant: 'participant',
      judge:       'judge'
    }
  end
end
