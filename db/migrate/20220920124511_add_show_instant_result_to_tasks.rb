class AddShowInstantResultToTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :show_instant_result, :boolean, default: false, null: false
  end
end
