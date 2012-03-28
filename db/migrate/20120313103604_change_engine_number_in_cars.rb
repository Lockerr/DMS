class ChangeEngineNumberInCars < ActiveRecord::Migration
  def up
    change_column :cars, :engine_number, :bigint
  end

  def down
  end
end
