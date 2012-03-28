class CreateDkps < ActiveRecord::Migration
  def change
    create_table :dkps do |t|
      t.integer :car_id
      t.decimal :price, :precision => 11, :scale => 2
      t.decimal :payment, :precision => 11, :scale => 2
      t.string :car_pts
      t.integer :contract_id
      t.timestamps
    end
  end
end
