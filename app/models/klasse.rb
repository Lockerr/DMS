class Klasse < ActiveRecord::Base
  has_many :cars
  has_many :models
  has_many :opts

end
