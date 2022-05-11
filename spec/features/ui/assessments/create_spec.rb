# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UI/Assessments/Create' do
  let!(:task) { create(:task) }
  let!(:task_criterium) { create(:task_criterium, task:) }
  let!(:judge_user) { create(:member, :judge, challenge: task.challenge).user }
  let!(:submission) do
    create(
      :task_submission,
      member: build(:member, challenge: task.challenge),
      notes:  'this is my submission',
      task:
    )
  end

  context 'without session' do
    it 'does not show task submissions' do
      visit "assessments/new?task_submission=#{submission.id}"

      expect(page).not_to have_button 'Create'
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end

  context 'with session' do
    before { assume_logged_in(judge_user) }

    it 'creates assessments' do
      visit "assessments/new?task_submission=#{submission.id}"

      expect(submission.task_assessments.count).to eq(0)

      fill_in 'Value', with: task_criterium.max_value
      fill_in 'Comment', with: 'Awesome job!'

      click_button 'Create'

      expect(submission.task_assessments.count).to eq(1)
      expect(page).to have_current_path "/tasks/#{task.slug}"
      expect(page).to have_content 'Task Assessment was successfully created'
      expect(page).not_to have_button 'Create'
      expect(page).not_to have_content 'Pending'
      expect(submission.task_assessments.first.comment).to eq('Awesome job!')
    end

    it 'shows errors' do
      visit "assessments/new?task_submission=#{submission.id}"

      expect(submission.task_assessments.count).to eq(0)

      fill_in 'Value', with: task_criterium.max_value + 1
      fill_in 'Comment', with: 'Awesome job!'

      click_button 'Create'

      expect(submission.task_assessments.count).to eq(0)
      expect(page).not_to have_current_path "/tasks/#{task.slug}"
      expect(page).not_to have_content 'Task Assessment was successfully created'
      expect(page).to have_content "can't be larger than criterium max value"
    end
  end
end
