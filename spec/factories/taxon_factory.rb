# frozen_string_literal: true

FactoryBot.define do
  factory :taxon, class: Repo::Taxon.name do
    sequence(:title) { |n| "Taxon-#{n}" }
    taxonomy
  end
end
