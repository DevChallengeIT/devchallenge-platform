class CreateTaskSubmissions < ActiveRecord::Migration[7.0]
  def change
    create_table :task_submissions do |t|
      t.references :task, null: false, foreign_key: true
      t.references :member, null: false, foreign_key: true
      t.text :notes

      t.timestamps
    end

    add_index :task_submissions, [:task_id, :member_id], unique: true
  end
end
