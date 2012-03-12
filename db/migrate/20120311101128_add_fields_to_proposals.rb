class AddFieldsToProposals < ActiveRecord::Migration
  def change
    add_column :proposals, :special_price, :integer
  end
end
