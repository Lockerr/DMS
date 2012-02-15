class Proposal < ActiveRecord::Base
  belongs_to :manager
  belongs_to :car
  belongs_to :person
  belongs_to :contract
end
