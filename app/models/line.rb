class Line < ActiveRecord::Base
  has_many :models
  has_many :cars
end
