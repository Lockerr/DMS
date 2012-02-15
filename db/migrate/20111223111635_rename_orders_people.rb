class RenameOrdersPeople < ActiveRecord::Migration
  def change
    rename_table :orders_people, :cars_people
  end
end
