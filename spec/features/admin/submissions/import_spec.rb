# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin/TaskSubmissions/Import' do
  it 'success' do
    challenge = create(:challenge)
    task = create(:task, challenge:)
    member_a = create(:member, challenge:)
    member_b = create(:member, challenge:)
    create(:task_submission, member: member_a, task:)

    assume_logged_in(admin: true)
    visit "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/submissions/import/new"

    fill_in 'Emails', with: "not-existing@exmaple.com\n#{member_a.user.email}\n#{member_b.user.email}"

    click_button 'Import'

    expect(page).to have_current_path "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/submissions"
    expect(page).to have_content 'Import has been successful'

    expect(Repo::TaskSubmission.count).to eq 2
    expect(Repo::TaskSubmission.all).to match_array(
      [
        have_attributes(
          task_id:   task.id,
          member_id: member_a.id,
          judge_id:  nil
        ),
        have_attributes(
          task_id:   task.id,
          member_id: member_b.id,
          judge_id:  nil
        )
      ]
    )
  end
end
