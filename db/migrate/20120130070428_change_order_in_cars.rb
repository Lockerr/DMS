class ChangeOrderInCars < ActiveRecord::Migration
  def up
    change_column :cars, :order, :string
  end

  def down
    change_column :cars, :order, :integer
  end
end
