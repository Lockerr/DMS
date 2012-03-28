class ChangeProposalPrice < ActiveRecord::Migration
  def up
    change_column :proposals, :price, :decimal, :precision => 15, :scale => 2
    change_column :proposals, :special_price, :decimal, :precision => 15, :scale => 2
  end

end
