# frozen_string_literal: true

FactoryBot.define do
  factory :taxonomy, class: Repo::Taxonomy.name do
    sequence(:title) { |n| "Taxonomy-#{n}" }
  end
end
