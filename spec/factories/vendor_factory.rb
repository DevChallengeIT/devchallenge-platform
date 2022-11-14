# frozen_string_literal: true

FactoryBot.define do
  factory :vendor, class: Repo::Vendor.name do
    sequence(:name) { |n| "Vendor-#{n}" }
  end
end
