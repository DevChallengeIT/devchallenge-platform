# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin/Results/Show' do
  let!(:challenge) { create(:challenge) }
  let!(:task) { create(:task, challenge:) }

  it 'failure without session' do
    visit "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/results"

    expect(page).to have_current_path '/login'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  it 'failure without admin account' do
    assume_logged_in
    visit "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/results"

    expect(page).to have_current_path '/'
    expect(page).to have_content 'Access denied'
  end

  it 'success' do
    task_criterium_a = create(:task_criterium, task:)
    task_criterium_b = create(:task_criterium, task:)
    participant_a = create(:member, challenge:)
    participant_b = create(:member, challenge:)
    judge_a = create(:member, :judge, challenge:)
    judge_b = create(:member, :judge, challenge:)

    task_submission_a = create(:task_submission, task:, member: participant_a)
    task_submission_b = create(:task_submission, task:, member: participant_b)

    create(:task_assessment, task_submission: task_submission_a, task_criterium: task_criterium_a, judge: judge_a, value: 10)
    create(:task_assessment, task_submission: task_submission_a, task_criterium: task_criterium_b, judge: judge_a, value: 7)
    create(:task_assessment, task_submission: task_submission_a, task_criterium: task_criterium_a, judge: judge_b, value: 8)
    create(:task_assessment, task_submission: task_submission_a, task_criterium: task_criterium_b, judge: judge_b, value: 8)

    create(:task_assessment, task_submission: task_submission_b, task_criterium: task_criterium_a, judge: judge_a, value: 6)
    create(:task_assessment, task_submission: task_submission_b, task_criterium: task_criterium_b, judge: judge_a, value: 3)
    create(:task_assessment, task_submission: task_submission_b, task_criterium: task_criterium_a, judge: judge_b, value: 4)
    create(:task_assessment, task_submission: task_submission_b, task_criterium: task_criterium_b, judge: judge_b, value: 2)

    assume_logged_in(admin: true)
    visit "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/results"

    expect(page).to have_current_path "/admin/challenges/#{challenge.slug}/tasks/#{task.slug}/results"

    # Sum
    within "#member-#{participant_a.id}-sum" do
      expect(page).to have_content '16'
    end

    within "#member-#{participant_b.id}-sum" do
      expect(page).to have_content '7'
    end

    # Values 1
    within "#member-#{participant_a.id}-criteria-#{task_criterium_a.id}-judge-#{judge_a.id}" do
      expect(page).to have_content '10'
    end

    within "#member-#{participant_a.id}-criteria-#{task_criterium_b.id}-judge-#{judge_a.id}" do
      expect(page).to have_content '7'
    end

    within "#member-#{participant_a.id}-criteria-#{task_criterium_a.id}-judge-#{judge_b.id}" do
      expect(page).to have_content '8'
    end

    within "#member-#{participant_a.id}-criteria-#{task_criterium_b.id}-judge-#{judge_b.id}" do
      expect(page).to have_content '8'
    end

    # Values 2
    within "#member-#{participant_b.id}-criteria-#{task_criterium_a.id}-judge-#{judge_a.id}" do
      expect(page).to have_content '6'
    end

    within "#member-#{participant_b.id}-criteria-#{task_criterium_b.id}-judge-#{judge_a.id}" do
      expect(page).to have_content '3'
    end

    within "#member-#{participant_b.id}-criteria-#{task_criterium_a.id}-judge-#{judge_b.id}" do
      expect(page).to have_content '4'
    end

    within "#member-#{participant_b.id}-criteria-#{task_criterium_b.id}-judge-#{judge_b.id}" do
      expect(page).to have_content '2'
    end

    # Avg 1
    within "#member-#{participant_a.id}-criteria-#{task_criterium_a.id}-avg" do
      expect(page).to have_content '9'
    end

    within "#member-#{participant_a.id}-criteria-#{task_criterium_b.id}-avg" do
      expect(page).to have_content '7'
    end

    within "#member-#{participant_a.id}-criteria-#{task_criterium_a.id}-avg" do
      expect(page).to have_content '9'
    end

    within "#member-#{participant_a.id}-criteria-#{task_criterium_b.id}-avg" do
      expect(page).to have_content '7'
    end

    # Avg 2
    within "#member-#{participant_b.id}-criteria-#{task_criterium_a.id}-avg" do
      expect(page).to have_content '5'
    end

    within "#member-#{participant_b.id}-criteria-#{task_criterium_b.id}-avg" do
      expect(page).to have_content '2'
    end

    within "#member-#{participant_b.id}-criteria-#{task_criterium_a.id}-avg" do
      expect(page).to have_content '5'
    end

    within "#member-#{participant_b.id}-criteria-#{task_criterium_b.id}-avg" do
      expect(page).to have_content '2'
    end
  end
end
