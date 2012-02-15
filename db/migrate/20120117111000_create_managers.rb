class CreateManagers < ActiveRecord::Migration
  def change
    create_table :managers do |t|
      t.string :name
    end
  end
end
