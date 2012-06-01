class RemoveContactPhoneFromContracts < ActiveRecord::Migration
  def up
    remove_column :contracts, :contact_phone
  end

  def down
  end
end
