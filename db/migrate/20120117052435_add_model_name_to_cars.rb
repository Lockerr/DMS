class AddModelNameToCars < ActiveRecord::Migration
  def change
    add_column :cars, :model_name, :string
  end
end
