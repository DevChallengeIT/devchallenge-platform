# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Competition::TaxonomiesQuery do
  let!(:taxonomy_a) { create(:taxonomy) }
  let!(:taxonomy_b) { create(:taxonomy) }

  it 'returns challenges taxonomies list' do
    create(:taxonomy_repo, taxonomy: taxonomy_a, repo: :challenges)
    create(:taxonomy_repo, taxonomy: taxonomy_b, repo: :challenges)
    result = Competition.list_taxonomies(repo: :challenges)

    expect(result.count).to eq 2
    expect(result).to include(taxonomy_a, taxonomy_b)
  end

  it 'returns users taxonomies list' do
    create(:taxonomy_repo, taxonomy: taxonomy_a, repo: :users)
    result = Competition.list_taxonomies(repo: :users)

    expect(result.count).to eq 1
    expect(result).to include(taxonomy_a)
  end

  it 'returns other taxonomies list' do
    result = Competition.list_taxonomies(repo: :other)

    expect(result).to eq([])
  end
end
