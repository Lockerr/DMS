class AddNextSubjectForCommunications < ActiveRecord::Migration
  def up
    add_column :communications, :next_subject, :string
  end

  def down
  end
end
