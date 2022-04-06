# frozen_string_literal: true

FactoryBot.define do
  factory :taxon, class: Repo::Taxon.name do
    sequence(:title) { |n| "Taxonomy-#{n}" }
    taxonomy
  end
end
