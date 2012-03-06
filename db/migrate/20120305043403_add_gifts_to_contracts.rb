class AddGiftsToContracts < ActiveRecord::Migration
  def change
    add_column :contracts, :gifts, :string
  end
end
