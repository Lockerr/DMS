class AddFieldsToPeople < ActiveRecord::Migration
  def change
    add_column :people, :model_id, :integer
    add_column :people, :model_name, :string
    add_column :people, :manager_id, :integer
    add_column :people, :manager_name, :string
    add_column :people, :order_id, :integer


  end
end
