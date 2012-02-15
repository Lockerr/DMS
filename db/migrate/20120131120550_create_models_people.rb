class CreateModelsPeople < ActiveRecord::Migration
  def up
    create_table :models_people do |t|
      t.integer :model_id
      t.integer :person_id
    end

    add_index :models_people, :model_id
    add_index :models_people, :person_id
    add_index :models_people, [:person_id, :model_id]


  end

  def down
  end
end
