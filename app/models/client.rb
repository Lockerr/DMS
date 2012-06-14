class Client < ActiveRecord::Base
  set_table_name '1_clients'
  has_one :car, :foreign_key => :order, :primary_key => :order

end
