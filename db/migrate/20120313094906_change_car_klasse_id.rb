class ChangeCarKlasseId < ActiveRecord::Migration
  def up
    change_column :cars, :klasse_id, :integer
  end

  def down
  end
end
