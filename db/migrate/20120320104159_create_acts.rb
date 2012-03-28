class CreateActs < ActiveRecord::Migration
  def change
    create_table :acts do |t|
      t.integer :car_id
      t.integer :person_id
      t.string :pts

      t.timestamps
    end
  end
end
