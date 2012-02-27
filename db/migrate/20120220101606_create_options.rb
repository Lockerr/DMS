class CreateOptions < ActiveRecord::Migration
  def up
    create_table :opts do |t|
      t.string :code
      t.string :desc
      t.string :pseudo_klasse
    end
  end

  def down
  end
end
