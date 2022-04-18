# frozen_string_literal: true

module Repo
  class TaskCriterium < ApplicationRecord
    belongs_to :task

    with_options presence: true do
      validates :task
      validates :max_value, numericality: { only_integer: true }
    end
  end
end
