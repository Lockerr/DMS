class CreateOrders < ActiveRecord::Migration
  def up
    create_table :orders do |t|
      t.string :source_id
      t.string :number
      t.string :problem
      t.string :solution
      t.string :master
      t.string :dispatcher
      t.string :sum
      t.datetime :opened
      t.datetime :closed
      t.datetime :gone
      t.integer :call_result
      t.text :description
      t.timestamps



    end
  end

  def down
  end
end
