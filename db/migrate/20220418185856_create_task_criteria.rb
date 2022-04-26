class CreateTaskCriteria < ActiveRecord::Migration[7.0]
  def change
    create_table :task_criteria do |t|
      t.string :title
      t.integer :max_value, null: false, default: 0
      t.references :task, null: false, index: true, foreign_key: true

      t.timestamps
    end
  end
end
