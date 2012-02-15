class AddDateToContrace < ActiveRecord::Migration
  def change
    add_column :contracts, :date, :date
  end
end
