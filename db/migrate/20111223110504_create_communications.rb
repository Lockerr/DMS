class CreateCommunications < ActiveRecord::Migration
  def up
    remove_column :people, :complectations
    add_column :people, :package, :string
  end

  def down
  end
end
