class CreateTaxonomiesRepos < ActiveRecord::Migration[7.0]
  def change
    create_table :taxonomy_repos do |t|
      t.references :taxonomy, index: true, foreign_key: { on_delete: :cascade }, null: false
      t.string :repo, null: false

      t.timestamps
    end

    add_index :taxonomy_repos, [:taxonomy_id, :repo], unique: true
  end
end
