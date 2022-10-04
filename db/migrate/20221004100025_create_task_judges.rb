class CreateTaskJudges < ActiveRecord::Migration[7.0]
  def change
    create_table :task_submission_judges do |t|
      t.references :task_submission, index: true, foreign_key: { on_delete: :cascade }, null: false
      t.references :judge, index: true, foreign_key: { to_table: :members, on_delete: :cascade }, null: false

      t.timestamps
    end
  end
end
