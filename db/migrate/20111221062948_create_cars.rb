class CreateCars < ActiveRecord::Migration
  def change
    create_table :cars do |t|
      t.integer :order
      t.string :klasse_id
      t.integer :model_id
      t.string :line_id
      t.integer :color_id
      t.integer :interior_id
      t.integer :price
      t.string :options
      t.integer :person_id
      t.string :state
      t.integer :published
      t.date :arrival
      t.string :days_at_stock
      t.string :comments
      t.string :vp
      t.string :insurace
      t.string :manager_id
      t.string :payment
      t.string :car_type
      t.string :run


      t.timestamps
    end
  end
end
