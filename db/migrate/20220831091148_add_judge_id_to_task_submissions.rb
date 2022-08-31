class AddJudgeIdToTaskSubmissions < ActiveRecord::Migration[7.0]
  def change
    add_reference :task_submissions, :judge, foreign_key: { to_table: :members }
  end
end
