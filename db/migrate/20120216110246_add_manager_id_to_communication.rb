class AddManagerIdToCommunication < ActiveRecord::Migration
  def change
    add_column :communications, :manager_id, :integer
  end
end
