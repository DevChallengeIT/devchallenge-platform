class CreateTaxonomies < ActiveRecord::Migration[7.0]
  def change
    create_table :taxonomies do |t|
      t.citext :title, null: false
      t.citext :slug, null: false

      t.timestamps
    end

    add_index :taxonomies, :title, unique: true
    add_index :taxonomies, :slug, unique: true
  end
end
