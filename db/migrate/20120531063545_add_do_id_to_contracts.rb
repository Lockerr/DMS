class AddDoIdToContracts < ActiveRecord::Migration
  def change
    add_column :contracts, :do_id, :integer
  end
end
