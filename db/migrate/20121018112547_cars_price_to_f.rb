class CarsPriceToF < ActiveRecord::Migration
  def up
  	change_column :cars, :price, :double
  end

  def down
  end
end
