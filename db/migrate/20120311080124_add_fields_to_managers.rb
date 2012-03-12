class AddFieldsToManagers < ActiveRecord::Migration
  def change
    add_column :managers, :mobile, :string
    add_column :managers, :email, :string
  end
end
