class AddFieldsToContract < ActiveRecord::Migration
  def change
    add_column :contracts, :prepay, :integer
    add_column :people, :birthday, :date
    add_column :people, :address, :string
    add_column :people, :id_series, :integer
    add_column :people, :id_number, :integer
    add_column :people, :id_dep, :string
    add_column :contracts, :contact_phone, :string
  end
end
