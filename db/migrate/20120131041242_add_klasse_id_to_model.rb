class AddKlasseIdToModel < ActiveRecord::Migration
  def change
    add_column :models, :klasse_id, :integer
  end
end
