class AddFieldsToActs < ActiveRecord::Migration
  def change
    add_column :acts, :car_pts, :string
    add_column :acts, :price, :decimal, :precision => 11, :scale => 2
    add_column :acts, :nds, :decimal, :precision => 11, :scale => 2
  end
end
