class Car < ActiveRecord::Base
  validates_presence_of :order
  validates_uniqueness_of :order

  belongs_to :model
  belongs_to :manager
  belongs_to :payment, :class_name => "Manager", :foreign_key => :payment_id
  belongs_to :person
  belongs_to :klasse
  belongs_to :line
  has_many :proposals
  has_one :contract
  has_many :checkins

  after_save :write_logs

  default_scope includes(:manager, :model, :person, :klasse, :line, :payment, :contract)

  self.include_root_in_json = false



  def write_logs(object=nil)
    Log.create(:model_name => 'car', :parameters => self.attributes, :object_id => ('system' if !object), :user_id => User.current_user)
  end



end
