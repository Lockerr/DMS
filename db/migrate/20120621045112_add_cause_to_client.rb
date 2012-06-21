class AddCauseToClient < ActiveRecord::Migration
  def change
    add_column '1_clients', :cause, :tinyint
  end
end
