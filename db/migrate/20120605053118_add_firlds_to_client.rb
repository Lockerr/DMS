class AddFirldsToClient < ActiveRecord::Migration
  def change
    add_column '1_clients', :order, :integer
    add_column '1_clients', :contract_date, :date
    add_column '1_clients', :id_series, :integer
    add_column '1_clients', :id_number, :integer
    add_column '1_clients', :id_dep, :string
    add_column '1_clients', :id_issued, :date
    add_column '1_clients', :gifts, :string
    add_column '1_clients', :prepay, :integer
  end
end
