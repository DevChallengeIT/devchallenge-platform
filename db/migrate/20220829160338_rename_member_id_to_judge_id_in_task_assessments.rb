class RenameMemberIdToJudgeIdInTaskAssessments < ActiveRecord::Migration[7.0]
  def change
    rename_column :task_assessments, :member_id, :judge_id
  end
end
