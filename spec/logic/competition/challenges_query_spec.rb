# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Competition::ChallengesQuery do
  let!(:challenge_a) { create(:challenge, title: 'Yellow') }
  let!(:challenge_b) { create(:challenge, title: 'Red') }

  context 'without params' do
    it 'returns all challenges' do
      result = Competition.list_actual_challenges
      expect(result.count).to eq 2
      expect(result).to include(challenge_a, challenge_b)
    end
  end

  context 'with search param' do
    it 'returns matched challenges' do
      result = Competition.list_actual_challenges(search: 'ELL')
      expect(result.count).to eq 1
      expect(result).to include(challenge_a)
    end
  end

  context 'with filter param' do
    let(:taxon_a) { create(:taxon) }
    let(:taxon_b) { create(:taxon) }
    let(:taxon_c) { create(:taxon) }

    before do
      create(:taxonomy_repo, taxonomy: taxon_a.taxonomy, repo: :challenges)
      create(:taxonomy_repo, taxonomy: taxon_b.taxonomy, repo: :challenges)
      create(:taxon_entity, taxon: taxon_a, entity: challenge_a)
      create(:taxon_entity, taxon: taxon_b, entity: challenge_b)
    end

    it 'returns matched challenges by one taxon' do
      result = Competition.list_actual_challenges(filter: { taxon_ids: [taxon_a.id] })
      expect(result.count).to eq 1
      expect(result).to include(challenge_a)
    end

    it 'returns matched challenges by multiple taxons' do
      result = Competition.list_actual_challenges(filter: { taxon_ids: [taxon_a.id, taxon_b.id] })
      expect(result.count).to eq 2
      expect(result).to include(challenge_a, challenge_b)
    end

    it 'returns empty result by missing taxons' do
      result = Competition.list_actual_challenges(filter: { taxon_ids: [taxon_c.id] })
      expect(result).to eq([])
    end
  end
end
