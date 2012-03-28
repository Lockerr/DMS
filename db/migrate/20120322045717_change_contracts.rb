class ChangeContracts < ActiveRecord::Migration
  def up
    change_column :contracts, :number, :string
  end

  def down
  end
end
