class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.string :model_name
      t.integer :object_id
      t.integer :user_id
      t.text :parameters

      t.timestamps
    end
  end
end
