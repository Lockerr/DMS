class Manager < ActiveRecord::Base
  has_many :cars
  has_many :payments, :foreign_key => :payment_id, :class_name => 'Car'
  has_many :contracts
  has_many :proposals
  has_many :communications


  def events_day

  end


  def events_week

  end


  def events_month

  end


  def events_year

  end





end
