class Checkin < ActiveRecord::Base
  has_many :assets, :as => :attachable, :dependent => :destroy
  belongs_to :car
end
