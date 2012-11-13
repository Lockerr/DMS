class AddMetallicToColors < ActiveRecord::Migration
  def change
    add_column :colors, :metallic, :boolean
  end
end
