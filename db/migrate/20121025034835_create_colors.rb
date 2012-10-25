class CreateColors < ActiveRecord::Migration
  def change
    create_table :colors do |t|
      t.string :code
      t.string :desc
      t.string :color

      t.timestamps
    end
  end
end
