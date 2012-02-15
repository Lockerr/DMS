class AddProdDateToCars < ActiveRecord::Migration
  def change
    add_column :cars, :prod_date, :date
  end
end
