class AddUniqueIndexForTaskAssesments < ActiveRecord::Migration[7.0]
  def change
    add_index :task_assessments, [:judge_id, :task_criterium_id, :task_submission_id], unique: true, name: :unique_index_for_task_assesments
  end
end
