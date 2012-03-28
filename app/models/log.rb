class Log < ActiveRecord::Base

  belongs_to :user

  serialize :parameters, Hash

end
