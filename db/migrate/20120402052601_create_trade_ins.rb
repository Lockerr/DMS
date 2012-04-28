class CreateTradeIns < ActiveRecord::Migration
  def change
    create_table :trade_ins do |t|
      t.integer :price
      t.boolean :owner
      t.integer :person_id
      t.text :desc


      t.timestamps
    end
  end
end
