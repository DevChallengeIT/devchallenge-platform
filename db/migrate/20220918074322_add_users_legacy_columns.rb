class AddUsersLegacyColumns < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :legacy_id, :string
    add_column :users, :phone_number, :string
  end
end
