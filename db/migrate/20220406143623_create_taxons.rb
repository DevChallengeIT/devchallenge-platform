class CreateTaxons < ActiveRecord::Migration[7.0]
  def change
    create_table :taxons do |t|
      t.citext :title, null: false
      t.citext :slug, null: false
      t.references :taxonomy, index: true, foreign_key: { on_delete: :cascade }, null: false

      t.timestamps
    end

    add_index :taxons, [:taxonomy_id, :title], unique: true
    add_index :taxons, [:taxonomy_id, :slug], unique: true
  end
end
