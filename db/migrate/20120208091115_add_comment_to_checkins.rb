class AddCommentToCheckins < ActiveRecord::Migration
  def change
    add_column :checkins, :comments, :string
  end
end
