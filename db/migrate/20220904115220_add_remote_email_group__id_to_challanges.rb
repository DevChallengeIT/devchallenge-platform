class AddRemoteEmailGroupIdToChallanges < ActiveRecord::Migration[7.0]
  def change
    add_column :challenges, :remote_email_group_id, :string
  end
end
