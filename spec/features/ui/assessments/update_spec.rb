# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UI/Assessments/Update' do
  let!(:task) { create(:task) }
  let!(:task_criterium) { create(:task_criterium, task:) }
  let!(:judge) { create(:member, :judge, challenge: task.challenge) }
  let!(:submission) do
    create(
      :task_submission,
      member: build(:member, challenge: task.challenge),
      notes:  'this is my submission',
      task:
    )
  end
  let!(:assessment) do
    create(
      :task_assessment,
      task_criterium:,
      task_submission: submission,
      member:          judge,
      value:           10,
      comment:         'nice job!!!'
    )
  end

  context "with judge's session" do
    before { assume_logged_in(judge.user) }

    it 'updates assessment' do
      visit "assessments/#{assessment.id}/edit?task_submission=#{submission.id}"

      expect(page).to have_field('Comment', with: assessment.comment)
      expect(submission.task_assessments.count).to eq(1)

      fill_in 'Value', with: 5
      fill_in 'Comment', with: 'not so nice :('

      click_button 'Update'

      expect(submission.task_assessments.count).to eq(1)
      expect(page).to have_current_path "/tasks/#{task.slug}"
      expect(page).to have_content 'Task Assessment was successfully updated'
      expect(page).not_to have_button 'Update'
      expect(submission.task_assessments.first.comment).to eq('not so nice :(')
    end

    it 'updates specific assessment' do
      second_criterium = create(:task_criterium, max_value: 15, task:)
      second_assessment = create(
        :task_assessment,
        task_criterium:  second_criterium,
        task_submission: submission,
        member:          judge,
        value:           9,
        comment:         'looks good'
      )

      visit "assessments/#{assessment.id}/edit?task_submission=#{submission.id}"

      expect(submission.task_assessments.count).to eq(2)
      expect(page).to have_field('Comment', with: assessment.comment)
      expect(page).to have_field('Comment', with: second_assessment.comment)

      within "#assessment-#{second_assessment.id}" do
        fill_in 'Value', with: 6
        fill_in 'Comment', with: 'not so nice :('
      end

      click_button 'Update'

      expect(submission.task_assessments.count).to eq(2)
      expect(page).to have_current_path "/tasks/#{task.slug}"
      expect(page).to have_content 'Task Assessment was successfully updated'
      expect(second_assessment.reload.comment).not_to eq('looks good')
      expect(second_assessment.comment).to eq('not so nice :(')
      expect(second_assessment.value).to eq(6)
      expect(assessment.reload.comment).to eq('nice job!!!')
    end

    it 'shows errors' do
      visit "assessments/#{assessment.id}/edit?task_submission=#{submission.id}"

      expect(submission.task_assessments.count).to eq(1)

      fill_in 'Value', with: task_criterium.max_value + 1
      fill_in 'Comment', with: 'Awesome job!'

      click_button 'Update'

      expect(submission.task_assessments.count).to eq(1)
      expect(page).not_to have_current_path "/tasks/#{task.slug}"
      expect(page).not_to have_content 'Task Assessment was successfully updated'
      expect(page).to have_content "can't be larger than criterium max value"
    end
  end

  context "with not judge's session" do
    it 'does not show task submissions if there is not session' do
      visit "assessments/#{assessment.id}/edit?task_submission=#{submission.id}"

      expect(page).not_to have_button 'Update'
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end

    it "redirects to root in case of regular admin's session" do
      assume_logged_in(admin: true)
      visit "assessments/#{assessment.id}/edit?task_submission=#{submission.id}"

      expect(page).to have_current_path root_path
      expect(page).to have_content 'Access denied'
    end

    it "redirects to root in case of participant's session" do
      assume_logged_in(submission.member.user)
      visit "assessments/#{assessment.id}/edit?task_submission=#{submission.id}"

      expect(page).to have_current_path root_path
      expect(page).to have_content 'Access denied'
    end
  end
end
