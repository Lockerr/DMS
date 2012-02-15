class ChangeColorAndInteriorInCars < ActiveRecord::Migration
  def up
    change_column :cars, :interior_id, :string
    change_column :cars, :color_id, :string
  end

end
