class AddTradeinsToClients < ActiveRecord::Migration
  def change
    add_column '1_clients', :trade_in_price, :integer
    add_column '1_clients', :trade_in_desc, :text
    add_column '1_clients', :used_vin, :string
  end
end
