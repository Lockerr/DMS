class CreateMbclubOptions < ActiveRecord::Migration
  def change
    create_table :mbclub_options do |t|

      t.timestamps
    end
  end
end
