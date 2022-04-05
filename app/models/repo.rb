# frozen_string_literal: true

module Repo
  delegate :transaction, to: ApplicationRecord
end
