class AddFieldsToCars < ActiveRecord::Migration
  def change
    add_column :cars, :gpl, :integer
    add_column :cars, :real_options, :string
    add_column :cars, :restyling, :boolean, :default => false
  end
end
