class AddUsedToCars < ActiveRecord::Migration
  def change
    add_column :cars, :used, :boolean, :default => false
  end
end
