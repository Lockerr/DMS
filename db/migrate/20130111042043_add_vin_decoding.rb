class AddVinDecoding < ActiveRecord::Migration
  def change
    add_column :cars do |t|
      t.string :chasis
      t.string :chasis_type
      t.string :end_user_price
  end

  
end
