class Person < ActiveRecord::Base
  has_many :communications
  has_and_belongs_to_many :orders, :class_name => 'Car'
  belongs_to :manager
  has_many :cars
  has_and_belongs_to_many :models
  has_many :contracts
  has_many :proposals

  after_save :write_logs


  def name_with_phone
    "#{name}, #{phones}"
  end

  def write_logs
    Log.create(:model_name => 'person', :parameters => self.attributes, :object_id => self.id, :user_id => User.current_user)
  end


end
