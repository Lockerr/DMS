class Manager < ActiveRecord::Base
  has_many :cars
  has_many :payments, :foreign_key => :payment_id, :class_name => 'Car'
  has_many :contracts
  has_many :proposals
end
