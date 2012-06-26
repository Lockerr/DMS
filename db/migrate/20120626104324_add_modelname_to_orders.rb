class AddModelnameToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :modelname, :string
  end
end
