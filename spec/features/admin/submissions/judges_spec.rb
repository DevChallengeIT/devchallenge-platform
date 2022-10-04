# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin/TaskSubmissions/Judges' do
  it 'success' do
    challenge = create(:challenge)
    task = create(:task, challenge:)
    judge = create(:member, :judge, challenge:)
    available_judge = create(:member, :judge, challenge:)
    task_submission = create(:task_submission, task:, judge:)

    assume_logged_in(admin: true)
    visit "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/submissions"

    within "td#judges-#{task_submission.id}" do
      expect(page).to have_content judge.user.full_name
      expect(page).to have_link '+', href: "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/submissions/#{task_submission.id}/judges"
      click_link '+'
    end

    expect(page).to have_current_path "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/submissions/#{task_submission.id}/judges"

    # Add judge
    within '#assigned-judges' do
      expect(page).to have_content 'None'
    end

    within '#potential-judges' do
      expect(page).to have_button available_judge.user.full_name
      click_button available_judge.user.full_name
    end

    within '#assigned-judges' do
      expect(page).to have_button available_judge.user.full_name
    end

    within '#potential-judges' do
      expect(page).to have_content 'None'
    end

    # Remove judge
    within '#assigned-judges' do
      click_button available_judge.user.full_name
      expect(page).to have_content 'None'
    end

    within '#potential-judges' do
      expect(page).to have_button available_judge.user.full_name
    end
  end

  it 'has additional judges' do
    challenge = create(:challenge)
    task = create(:task, challenge:)
    judge = create(:member, :judge, challenge:)
    additional_judge = create(:member, :judge, challenge:)
    task_submission = create(:task_submission, task:, judge:)
    create(:task_submission_judge, task_submission:, judge: additional_judge)

    assume_logged_in(admin: true)
    visit "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/submissions"

    within "td#judges-#{task_submission.id}" do
      expect(page).to have_content judge.user.full_name
      expect(page).to have_content additional_judge.user.full_name
      expect(page).to have_link '+', href: "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/submissions/#{task_submission.id}/judges"
      click_link '+'
    end
  end
end
