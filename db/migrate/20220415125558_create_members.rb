class CreateMembers < ActiveRecord::Migration[7.0]
  def change
    create_enum :member_role, %w[participant judge]

    create_table :members do |t|
      t.enum :role, enum_type: :member_role, default: 'participant', null: false
      t.references :user, index: true, foreign_key: true
      t.references :challenge, index: true, foreign_key: true

      t.timestamps
    end

    add_index :members, :role
  end
end
