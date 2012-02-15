class ChangeCommunications < ActiveRecord::Migration
  def up
    change_column :communications, :next_action_date, :datetime
  end

  def down
  end
end
