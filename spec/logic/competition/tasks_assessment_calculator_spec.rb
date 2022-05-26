# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Competition::TasksAssessmentCalculator do
  subject(:calculator) { described_class.total_assessment_for(participant:, task:) }

  let(:participant) { create(:member) }
  let(:task) do
    create(
      :task,
      challenge:        participant.challenge,
      task_submissions: create_list(
                          :task_submission,
                          1,
                          task_assessments: [
                                              create(:task_assessment, value: values[0]),
                                              create(:task_assessment, value: values[1]),
                                              create(:task_assessment, value: values[2])
                                            ],
                          member:           participant
                        ),
      min_assessment:   27
    )
  end
  let(:values) { [4, 10, 7] }

  it 'returns a sum of all assessments for a participant submission' do
    expect(calculator).to eql values.sum
  end
end
