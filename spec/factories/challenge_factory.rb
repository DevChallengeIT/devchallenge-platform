# frozen_string_literal: true

FactoryBot.define do
  factory :challenge, class: Repo::Challenge.name do
    status          { 'live' }
    title           { FFaker::Lorem.phrase }
    registration_at { '2022-04-01 10:00:00' }
    start_at        { '2022-04-10 09:00:00' }
    finish_at       { '2022-04-15 18:00:00' }
  end
end
