# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UI/Tasks/Show' do
  let!(:task) { create(:task) }

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

    context 'when member is a challenge judge' do
      it 'shows correct task submissions' do
        assume_logged_in

        create(:member, :judge, user: current_user, challenge: task.challenge)
        participant = create(:member, challenge: task.challenge)
        current_task_submission = create(:task_submission, member: participant, notes: 'this is my submission', task:)
        another_task_submission = create(:task_submission, notes: 'not current task submission')

        visit "/tasks/#{task.slug}"

        expect(page).to have_current_path "/tasks/#{task.slug}"
        expect(page).to have_link 'Add assessment'
        expect(page).not_to have_link 'Edit assessment'
        expect(page).to have_content 'Submissions'
        expect(page).to have_content current_task_submission.notes
        expect(page).not_to have_content another_task_submission.notes
      end
    end

    context 'when member is not a challenge judge' do
      it 'redirects to root' do
        assume_logged_in

        create(:member, :judge, user: current_user)
        participant = create(:member, challenge: task.challenge)
        task_submission = create(:task_submission, member: participant, notes: 'this is my submission', task:)

        visit "/tasks/#{task.slug}"

        expect(page).to have_current_path root_path
        expect(page).not_to have_link 'Add assessment'
        expect(page).to have_content 'Access denied'
        expect(page).not_to have_content task_submission.notes
      end
    end

    it 'can access as admin' do
      assume_logged_in(admin: true)

      visit "/tasks/#{task.slug}"

      expect(page).to have_current_path "/tasks/#{task.slug}"
      expect(page).to have_link 'Edit'
    end
  end
end
