class AddVinToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :vin, :string
  end
end
