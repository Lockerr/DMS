class ConvertRealOptions < ActiveRecord::Migration
  def up
    change_column :cars, :real_options, :text
  end


end


