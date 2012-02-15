class ChangeActionDateForCommunications < ActiveRecord::Migration
  def change
    change_column :communications, :action_date, :datetime
  end
end
