class AddKlasseIdToOpts < ActiveRecord::Migration
  def change
    add_column :opts, :klasse_id, :integer
  end
end
