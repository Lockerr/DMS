class CreateMCars < ActiveRecord::Migration
  def change
    create_table :m_cars do |t|

      t.timestamps
    end
  end
end
