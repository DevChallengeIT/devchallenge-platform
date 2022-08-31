# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UI/Tasks/Show' do
  let!(:task) { create(:task, min_assessment: 10) }

  context 'without session' do
    it 'can not access' do
      visit "/tasks/#{task.slug}"

      expect(page).to have_current_path '/login'
      expect(page).to have_content 'You need to sign in or sign up'
    end
  end

  context 'with session' do
    it 'can not access without challenge membership' do
      assume_logged_in

      visit "/tasks/#{task.slug}"

      expect(page).to have_current_path '/'
      expect(page).to have_content 'Access denied'
    end

    it 'can access with challenge membership' do
      assume_logged_in
      member = create(:member, user: current_user, challenge: task.challenge)
      expect(member).to be_participant

      visit "/tasks/#{task.slug}"

      expect(page).to have_current_path "/tasks/#{task.slug}"
      expect(page).not_to have_link 'Edit'
    end

    it 'can access as admin' do
      assume_logged_in(admin: true)

      visit "/tasks/#{task.slug}"

      expect(page).to have_current_path "/tasks/#{task.slug}"
      expect(page).to have_link 'Edit'
    end
  end

  context 'without dependency' do
    it 'can see 0 result' do
      assume_logged_in
      create(:member, user: current_user, challenge: task.challenge)

      visit "/tasks/#{task.slug}"

      within '#result' do
        expect(page).to have_content 'Result: 0'
        expect(page).not_to have_content 'You are not qualified'
      end
    end
  end

  context 'with dependency' do
    it 'can see 0 result and not qualified message' do
      assume_logged_in
      create(:member, user: current_user, challenge: task.challenge)
      create(:task, dependent_task: task, min_assessment: 100)

      visit "/tasks/#{task.slug}"

      within '#result' do
        expect(page).to have_content 'Result: 0'
        expect(page).to have_content 'You are not qualified'
      end
    end

    it 'can see some result and qualified message' do
      assume_logged_in

      member = create(:member, user: current_user, challenge: task.challenge)
      dependent_task = create(:task, dependent_task: task, challenge: task.challenge)
      judge = create(:member, :judge, challenge: task.challenge)
      task_criterium = create(:task_criterium, task:)
      task_submission = create(:task_submission, task:, member:)
      create(:task_assessment, task_submission:, task_criterium:, judge:, value: 10)

      visit "/tasks/#{task.slug}"

      within '#result' do
        expect(page).to have_content 'Result: 10'
        expect(page).to have_content "You are qualified to: #{dependent_task.title}"
      end
    end
  end
end
