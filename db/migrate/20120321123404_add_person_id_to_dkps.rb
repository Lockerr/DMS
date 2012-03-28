class AddPersonIdToDkps < ActiveRecord::Migration
  def change
    add_column :dkps, :person_id, :integer
  end
end
