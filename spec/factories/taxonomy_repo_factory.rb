# frozen_string_literal: true

FactoryBot.define do
  factory :taxonomy_repo, class: Repo::TaxonomyRepo.name do
    sequence(:repo) { 'challenge' }
    taxonomy
  end
end
