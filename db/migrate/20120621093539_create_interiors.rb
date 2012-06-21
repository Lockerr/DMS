class CreateInteriors < ActiveRecord::Migration
  def change
    create_table :interiors do |t|
      t.string :desc
      t.string :code
      t.integer :klasse_id
    end
  end

end
