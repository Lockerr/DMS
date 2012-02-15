class CreateContracts < ActiveRecord::Migration
  def change
    create_table :contracts do |t|
      t.integer :person_id
      t.integer :car_id
      t.integer :manager_id
      t.integer :price

      t.timestamps
    end
  end
end
