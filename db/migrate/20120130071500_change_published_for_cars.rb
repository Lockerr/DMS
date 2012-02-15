class ChangePublishedForCars < ActiveRecord::Migration
  def up
    change_column :cars, :published, :boolean, :default => false
    Car.update_all(:published => 0)
  end

  def down
  end
end
