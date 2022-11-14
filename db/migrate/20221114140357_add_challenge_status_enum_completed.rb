class AddChallengeStatusEnumCompleted < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      ALTER TYPE challenge_status ADD VALUE 'completed';
    SQL
  end

  def down
  end
end
