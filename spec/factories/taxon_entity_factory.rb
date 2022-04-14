# frozen_string_literal: true

FactoryBot.define do
  factory :taxon_entity, class: Repo::TaxonEntity.name do
    taxon
    association :entity, factory: :challenge
  end
end
