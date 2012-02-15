class CreatePeople < ActiveRecord::Migration
  def up
    create_table :people do |t|
      t.string :name
      t.string :phones
      t.string :email
      t.string :descriptions
      t.string :city
      t.string :complectations
      t.timestamps
    end

    create_table :communications do |t|
      t.integer :person_id
      t.string :subject
      t.string :action
      t.string :form_action
      t.date :action_date
      t.string :next_action
      t.string :next_action_form
      t.date :next_action_date
      t.string :descriptions
      t.timestamps
    end

    create_table :orders_people do |t|
      t.integer :person_id
      t.integer :order_id
    end

    create_table :communications_orders do |t|
      t.integer :communication_id
      t.integer :order_id
    end
  end
  def down
    drop_table :people
    drop_table :communications
    drop_table :orders_people
    drop_table :communications_orders

  end
end

