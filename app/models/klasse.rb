#encoding: utf-8
class Klasse < ActiveRecord::Base
  has_many :cars
  has_many :models
  has_many :opts

  def m_cars
    MCar.where(:class => name)
  end

  def cedan
    if name == 'C'
        ' седан'
    elsif name == 'E'
        ' седан'
    else
        nil
    end
  end

end
