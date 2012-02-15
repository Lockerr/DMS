class CreateModel < ActiveRecord::Migration
  def up
    create_table :models, :force => true do |t|
      t.string :name
      t.string :klasse
      t.integer :cars_count
    end
  end

  def down
    drop_table :models
  end
end