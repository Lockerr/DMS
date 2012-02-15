class CreateCheckins < ActiveRecord::Migration
  def change
    create_table :checkins do |t|
      t.integer :car_id
      t.boolean :damage
      t.timestamps
    end
  end
end
