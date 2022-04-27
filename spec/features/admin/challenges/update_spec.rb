# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin/Challenges/Update' do
  let!(:challenge) { create(:challenge) }

  it 'failure without session' do
    visit "/admin/challenges/#{challenge.slug}/edit"

    expect(page).to have_current_path '/login'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  it 'failure without admin account' do
    assume_logged_in
    visit "/admin/challenges/#{challenge.slug}/edit"

    expect(page).to have_current_path '/'
    expect(page).to have_content 'Access denied'
  end

  it 'failure with empty title' do
    assume_logged_in(admin: true)
    visit "/admin/challenges/#{challenge.slug}/edit"

    fill_in 'Title', with: ''
    click_button 'Update'
    within '#title-errors' do
      expect(page).to have_content "can't be blank"
    end

    expect(page).to have_current_path "/admin/challenges/#{challenge.slug}"
    expect(page).not_to have_content 'Challenge was successfully updated'
  end

  it 'failure with invalid timestamps' do
    assume_logged_in(admin: true)
    visit "/admin/challenges/#{challenge.slug}/edit"

    fill_in 'Registration at', with: '2022-04-06 15:33:14'
    fill_in 'Start at',        with: '2022-04-06 15:33:13'
    fill_in 'Finish at',       with: '2022-04-06 15:33:12'
    click_button 'Update'

    within '#registration_at-errors' do
      expect(page).to have_content 'must be less than 2022-04-06 15:33:13 UTC'
    end

    within '#start_at-errors' do
      expect(page).to have_content 'must be less than 2022-04-06 15:33:12 UTC'
    end

    within '#finish_at-errors' do
      expect(page).to have_content 'must be greater than 2022-04-06 15:33:13 UTC'
    end

    expect(page).to have_current_path "/admin/challenges/#{challenge.slug}"
    expect(page).not_to have_content 'Challenge was successfully updated'
  end

  it 'success' do
    assume_logged_in(admin: true)
    visit "/admin/challenges/#{challenge.slug}/edit"

    expect(page).to have_link 'View', href: "/challenges/#{challenge.slug}"
    expect(page).to have_link 'Tasks', href: "/admin/challenges/#{challenge.slug}/tasks"
    expect(page).to have_link 'Members', href: "/admin/challenges/#{challenge.slug}/members"

    fill_in 'Title',                with: 'OK challenge'
    select 'ready',                 from: 'Status'
    fill_in 'Slug',                 with: 'ok-challnege'
    # fill_in 'Description',          with: 'Lorem description' # TOOD: Fix trix
    # fill_in 'Terms and conditions', with: 'Lorem terms' # TODO: Fix trix
    fill_in 'Registration at',      with: '2022-05-01 10:00:00'
    fill_in 'Start at',             with: '2022-05-10 09:00:00'
    fill_in 'Finish at',            with: '2022-05-15 18:00:00'

    click_button 'Update'

    expect(page).to have_current_path '/admin/challenges/ok-challnege/edit'
    expect(page).to have_content 'Challenge was successfully updated'

    visit '/admin/challenges'
    within "#challenge-#{challenge.id}" do
      expect(page).to have_content 'OK challenge'
      expect(page).to have_content 'ready'
      expect(page).to have_content Time.zone.parse('2022-05-01 10:00:00').strftime(UI::TimestampComponent::TIME_FORMAT)
      expect(page).to have_content Time.zone.parse('2022-05-10 09:00:00').strftime(UI::TimestampComponent::TIME_FORMAT)
      expect(page).to have_content Time.zone.parse('2022-05-15 18:00:00').strftime(UI::TimestampComponent::TIME_FORMAT)
    end
  end

  it 'success with taxons' do
    taxonomy = create(:taxonomy)
    create(:taxonomy_repo, repo: :challenges, taxonomy:)
    taxon_a = create(:taxon, taxonomy:)
    taxon_b = create(:taxon, taxonomy:)
    challenge.taxons << taxon_a

    assume_logged_in(admin: true)
    visit "/admin/challenges/#{challenge.slug}/edit"
    expect(page).to have_checked_field taxon_a.title
    expect(page).to have_unchecked_field taxon_b.title

    uncheck taxon_a.title
    check taxon_b.title

    click_button 'Update'

    expect(page).to have_current_path "/admin/challenges/#{challenge.slug}/edit"
    expect(page).to have_content 'Challenge was successfully updated'

    visit "/admin/challenges/#{challenge.slug}/edit"
    expect(page).to have_unchecked_field taxon_a.title
    expect(page).to have_checked_field taxon_b.title
  end
end
