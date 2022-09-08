# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UI/Challenges/Index' do
  it 'displays actual challenges' do
    challenge_draft = create(:challenge, status: 'draft')
    challenge_moderation = create(:challenge, status: 'moderation')
    challenge_canceled = create(:challenge, status: 'canceled')

    challenge = create(:challenge, status: 'ready')

    visit '/'

    expect(page).to have_link challenge.title, href: "/challenges/#{challenge.slug}"
    expect(page).not_to have_link challenge_draft.title
    expect(page).not_to have_link challenge_moderation.title
    expect(page).not_to have_link challenge_canceled.title
  end

  it 'can search' do
    challenge_a = create(:challenge, title: 'Yellow')
    challenge_b = create(:challenge, title: 'Blue')

    assume_logged_in(admin: true)
    visit '/'
    fill_in 'search', with: 'ELL'
    click_button 'Search'

    expect(page).to have_content challenge_a.title
    expect(page).not_to have_content challenge_b.title
  end

  it 'can filter by taxons' do
    challenge_a = create(:challenge)
    challenge_b = create(:challenge)

    taxonomy_a = create(:taxonomy)
    taxonomy_b = create(:taxonomy)

    create(:taxonomy_repo, taxonomy: taxonomy_a, repo: :challenges)
    create(:taxonomy_repo, taxonomy: taxonomy_b, repo: :challenges)

    taxon_a = create(:taxon, taxonomy: taxonomy_a)
    taxon_b = create(:taxon, taxonomy: taxonomy_b)

    create(:taxon_entity, entity: challenge_a, taxon: taxon_a)
    create(:taxon_entity, entity: challenge_a, taxon: taxon_b)
    create(:taxon_entity, entity: challenge_b, taxon: taxon_a)

    visit '/'

    # Filter by taxon_a
    check taxon_a.title
    click_button 'Filter'

    expect(page).to have_checked_field taxon_a.title
    expect(page).not_to have_checked_field taxon_b.title
    expect(page).to have_content challenge_a.title
    expect(page).to have_content challenge_b.title

    # Filter by taxon_a + taxon_b
    check taxon_b.title
    click_button 'Filter'

    expect(page).to have_checked_field taxon_a.title
    expect(page).to have_checked_field taxon_b.title
    expect(page).to have_content challenge_a.title
    expect(page).to have_content challenge_b.title

    # Filter by taxon_b
    uncheck taxon_a.title
    click_button 'Filter'

    expect(page).not_to have_checked_field taxon_a.title
    expect(page).to have_checked_field taxon_b.title
    expect(page).to have_content challenge_a.title
    expect(page).not_to have_content challenge_b.title
  end

  it 'handles pagination' do
    challenge_a = create(:challenge)
    challenge_b = create(:challenge)

    assume_logged_in(admin: true)
    visit '/challenges?per_page=1'

    within '.pagination' do
      expect(page).to have_css "span[class='page active']", text: '1'
      expect(page).to have_css "a[href='/challenges?per_page=1&page=2']", text: '2'
      expect(page).to have_css "a[href='/challenges?per_page=1&page=2']", text: 'Next'
    end

    expect(page).to have_css "#challenge-#{challenge_a.id}"
    expect(page).not_to have_css "#challenge-#{challenge_b.id}"

    within '.pagination' do
      click_link 'Next'
      expect(page).to have_current_path '/challenges?per_page=1&page=2'
    end

    expect(page).to have_css "#challenge-#{challenge_b.id}"
    expect(page).not_to have_css "#challenge-#{challenge_a.id}"
  end

  it 'displays time_zone info if time_zone == UTC and current_user not updated profile' do
    assume_logged_in
    visit '/challenges'

    expect(page).to have_content 'Please check your profile time zone configuration'
  end

  it 'does not display time_zone info if time_zone != UTC' do
    user = create(:user, time_zone: 'EET')
    assume_logged_in(user)
    visit '/challenges'

    expect(page).not_to have_content 'Please check your profile time zone configuration'
  end
end
