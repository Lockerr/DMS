class Klasse < ActiveRecord::Base
  has_many :cars
  has_many :models
  has_many :opts

  def m_cars
    MCar.where(:class => name)
  end

end
