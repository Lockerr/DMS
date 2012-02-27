class AddEngineNumberToCars < ActiveRecord::Migration
  def change
    add_column :cars, :engine_number, :integer
  end
end
