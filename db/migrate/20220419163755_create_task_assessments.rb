class CreateTaskAssessments < ActiveRecord::Migration[7.0]
  def change
    create_table :task_assessments do |t|
      t.integer :value, null: false, default: 0
      t.text :comment
      t.references :member, null: false, foreign_key: true
      t.references :task_criterium, null: false, foreign_key: true
      t.references :task_submission, null: false, foreign_key: true

      t.timestamps
    end
  end
end
