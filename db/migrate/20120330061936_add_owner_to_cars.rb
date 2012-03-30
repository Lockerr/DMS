class AddOwnerToCars < ActiveRecord::Migration
  def change
    add_column :cars, :owner, :boolean, :default => true
  end
end
