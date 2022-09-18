# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::UsersQuery do
  let!(:users_list) { create_list(:user, 10) }

  context 'without search param' do
    subject(:result) { Users.list_users }

    it 'returns all users' do
      expect(result).to match_array users_list
    end
  end

  context 'with search param' do
    subject(:result) { Users.list_users(search: search_text) }

    let!(:user_by_email) { create(:user, email: "rick.dou#{search_text}@gmail.com") }
    let!(:user_by_full_name) { create(:user, full_name: "John Brand#{search_text}") }
    let(:search_text) { 'son' }

    it 'returns matched uses' do
      expect(result).to contain_exactly(user_by_email, user_by_full_name)
    end

    context 'with blank search param' do
      let(:search_text) { '' }

      it 'returns all users' do
        expect(result).to contain_exactly(*users_list, user_by_email, user_by_full_name)
      end
    end
  end
end
