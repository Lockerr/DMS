class RenameOrdersCars < ActiveRecord::Migration
  def change
    rename_column :cars_people, :order_id, :car_id
  end


end
