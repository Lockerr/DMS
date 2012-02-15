class CreateProposals < ActiveRecord::Migration
  def change
    create_table :proposals do |t|
      t.integer :person_id
      t.integer :car_id
      t.integer :manager_id
      t.integer :price

      t.timestamps
    end
  end
end
