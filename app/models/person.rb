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

  def short_name
    n = name.split(/(\s|\.)/).delete_if {|i| i == '.' || i == ' '}

    if n.count == 3
      "#{n[0]} #{n[1][0]}. #{n[2][0]}."
    else
      self.name
    end
  end

end
