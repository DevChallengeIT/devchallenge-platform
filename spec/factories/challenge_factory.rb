# frozen_string_literal: true

FactoryBot.define do
  factory :challenge, class: Repo::Challenge.name do
    status { 'ready' }
    sequence(:title) { |n| "Challenge-#{n}" }
    registration_at { Time.zone.now - 3.days }
    start_at        { Time.zone.now + 2.days }
    finish_at       { Time.zone.now + 2.weeks }

    trait :registration_not_opened do
      registration_at { Time.zone.now + 1.day }
      start_at        { Time.zone.now + 2.days }
    end

    trait :registration_closed do
      start_at { Time.zone.now - 1.day }
    end
  end
end
