class Contract < ActiveRecord::Base
  belongs_to :manager
  belongs_to :car
  belongs_to :person
  has_many :proposals
end
