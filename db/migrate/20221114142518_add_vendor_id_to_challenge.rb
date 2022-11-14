class AddVendorIdToChallenge < ActiveRecord::Migration[7.0]
  def change
    add_reference :challenges, :vendor
  end
end
