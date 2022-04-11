# frozen_string_literal: true

module Repo
  class Task < ApplicationRecord
    extend FriendlyId
    friendly_id :title, use: :slugged

    belongs_to :challenge
    belongs_to :dependent_task, class_name: 'Repo::Task', optional: true
  end
end
