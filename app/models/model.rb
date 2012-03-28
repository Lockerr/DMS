class Model < ActiveRecord::Base
  has_many :cars
  has_and_belongs_to_many :people, :uniq => true
end
