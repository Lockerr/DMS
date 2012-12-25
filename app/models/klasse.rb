#encoding: utf-8
class Klasse < ActiveRecord::Base
  has_many :cars
  has_many :models
  has_many :opts

  def m_cars
    MCar.where(:class => name)
  end

  def cedan
    if client.car.klasse.name == 'C'
        ' седан'
    elsif client.car.klasse.name == 'E'
        ' седан'
    else
        nil
    end
  end

end
