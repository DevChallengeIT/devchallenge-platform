class AddRequireFileToTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :require_attachment, :boolean, default: false
  end
end
