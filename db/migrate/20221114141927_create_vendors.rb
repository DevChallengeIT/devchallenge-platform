class CreateVendors < ActiveRecord::Migration[7.0]
  def change
    create_table :vendors do |t|
      t.citext :name

      t.timestamps
    end

    add_index :vendors, :name, unique: true
  end
end
