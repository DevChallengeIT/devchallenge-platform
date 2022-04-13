class CreateTaxonEntities < ActiveRecord::Migration[7.0]
  def change
    create_table :taxon_entities do |t|
      t.references :taxon, index: true, foreign_key: { on_delete: :cascade }, null: false
      t.integer :entity_id, null: false
      t.string :entity_type, null: false

      t.timestamps
    end

    add_index :taxon_entities, %i[taxon_id entity_id entity_type], unique: true
  end
end
