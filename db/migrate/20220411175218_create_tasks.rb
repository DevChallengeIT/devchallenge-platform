class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.citext :title, null: false
      t.citext :slug, null: false
      t.text :description
      t.references :challenge, null: false, foreign_key: true
      t.datetime :start_at
      t.datetime :submit_at
      t.datetime :result_at
      t.references :dependent_task, index: true, foreign_key: { to_table: :tasks }
      t.integer :min_assestment

      t.timestamps
    end

    add_index :tasks, [:title, :challenge_id], unique: true
    add_index :tasks, [:slug, :challenge_id], unique: true
  end
end
