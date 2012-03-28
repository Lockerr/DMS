class AddNumberToContracts < ActiveRecord::Migration
  def change
    add_column :contracts, :number, :integer
  end
end
