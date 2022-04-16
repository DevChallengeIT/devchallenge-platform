# frozen_string_literal: true

FactoryBot.define do
  factory :member, class: Repo::Member.name do
    user
    challenge

    trait :judge do
      role { 'judge' }
    end
  end
end
