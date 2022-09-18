# frozen_string_literal: true

class ApplicationJob < ActiveJob::Base
  SKIP_ERROR_MESSGAES = [
    'Subscriber type is unsubscribed',
    'Email temporarily blocked',
    'Subscriber type is bounced',
    'Subscriber type is junk',
    'Subscriber type is unconfirmed'
  ].freeze

  # Automatically retry jobs that encountered a deadlock
  retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  discard_on ActiveJob::DeserializationError
end
