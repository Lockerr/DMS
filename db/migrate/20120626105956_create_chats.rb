class CreateChats < ActiveRecord::Migration
  def change
    add_column :cars, :used_vin, :string
  end
end
