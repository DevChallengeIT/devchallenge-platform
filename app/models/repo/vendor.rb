# frozen_string_literal: true

module Repo
  class Vendor < ApplicationRecord
    validates :name, presence: true
    validates :name, uniqueness: { case_sensitive: true }
  end
end
