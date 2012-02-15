class AddManagerNameToCars < ActiveRecord::Migration
  def change
    add_column :cars, :manager_name, :string
  end
end
