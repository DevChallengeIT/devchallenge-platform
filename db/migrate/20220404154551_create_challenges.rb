class CreateChallenges < ActiveRecord::Migration[7.0]
  def change
    create_enum :challenge_status, %w[draft moderation pending registration live complete canceled]

    create_table :challenges do |t|
      t.enum :status, enum_type: :challenge_status, default: 'draft', null: false
      t.string :title, null: false
      t.string :slug, null: false
      t.text :description
      t.text :terms_and_conditions
      t.datetime :registration_at
      t.datetime :start_at
      t.datetime :finish_at

      t.timestamps
    end

    add_index :challenges, :status
    add_index :challenges, :title
    add_index :challenges, :slug, unique: true
  end
end
