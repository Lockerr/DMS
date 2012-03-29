class SetContractPriceToDecimal < ActiveRecord::Migration
  def up
   change_column :contracts, :price, :decimal , :precision => 11, :scale => 2
  end
end
