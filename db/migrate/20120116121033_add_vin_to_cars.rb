class AddVinToCars < ActiveRecord::Migration
  def change
    add_column :cars, :vin, :string
    add_column :cars, :description, :string
    rename_column :cars, :insurace, :insurance
  end
end
