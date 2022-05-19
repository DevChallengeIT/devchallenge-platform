class FixTypoInMinAssessmentColumnForTasks < ActiveRecord::Migration[7.0]
  def change
    rename_column :tasks, :min_assestment, :min_assessment
  end
end
