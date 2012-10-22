# encoding: utf-8
class Car < ActiveRecord::Base
  serialize :real_options, Array

  validates_presence_of :order
  validates_uniqueness_of :order
  has_many :logs, :foreign_key => :object_id, :conditions => ['model_name = ?', 'car']
  belongs_to :model
  belongs_to :manager
  belongs_to :payment, :class_name => "Manager", :foreign_key => :payment_id
  belongs_to :person
  belongs_to :klasse
  belongs_to :line
  has_one :proposal
  has_one :contract
  has_many :checkins
  has_one :act
  has_one :dkp
  belongs_to :client

  after_create :check_for_mbclub_presence
  after_update :check_for_mbclub_presence




  self.include_root_in_json = false

  def check_for_mbclub_presence

  end  

  def update_at_mbclub

  end

  def put_to_mbclub
    unless presence_at_mbclub?
      prepare_for_mbclub.save 
      write_options
    end
  end

  def self.put_all_cars_to_mbclub
    Car.all.each do |car|
      unless car.presence_at_mbclub?
        car.prepare_for_mbclub.save 
        car.write_options
      end
    end
  end





  def prepare_for_mbclub
    attributes = {
      :ordernum => order,
      :vin => vin,
      :name => model.name,
      :class_name => klasse.name,
      :end_cost => price,
      :model => (/(\d+)/.match(model.name)).to_a[0],
      :sold => 1
    }
    mcar = MCar.new
    mcar.attributes = attributes
    mcar.attributes.except('id').each do |k,v|
      mcar[k] = 0 unless v
    end
    mcar
  end

  def presence_at_mbclub?
    MCar.find_by_ordernum(order) ? true : false
  end
 
  def update_at_mbclub
    true
  end

  def write_logs(object=nil)
    if self.changes.any?
      Log.create(:model_name => 'car', :parameters => self.changes, :object_id => self.id, :user_id => User.current_user)
    end
  end
  
  def write_options
    ActiveRecord::Base.transaction do
      codes.each do |key, value|
        unless value == 'Опция неизвестна'
          transaction do 
            MOption.find_or_create_by_cars_orderno_and_opt_id(order, key, :opt_name => value, :opt_cost => 0)          
          end
        end
      end
    end
  end

  def order_with_model
    "#{order}, #{model.name}"
  end

  def codes
    result = {}

    opts = self.real_options
    for option in opts
      if o = self.klasse.opts.find_by_code(option)
        result[option] = o.desc
      else
        result[option] = 'Опция неизвестна'
      end
    end
    result

  end

  state_machine :state, :initial => :ordered do

    def initialize
      @client = person
      super()
    end

    after_failure do |car, transition|
      Rails.logger.error "vehicle #{car} failed to transition on #{transition.event}"
    end

    event :arrived do
      transition :ordered => :on_checkin
    end

    event :checkin do
      transition all => :pending
    end

    event :propose do
      transition :pending => :proposed
    end

    event :sell do
      transition all => :sold
    end

    event :transmit do
      transition :sold => :transmitted
    end

    state all - [:sold, :transmitted] do
      def can_be_sold?
        true
      end
    end

    state :sold, :transmitted do
      def can_be_sold?
        false
      end

      def can_be_proposed?
        false
      end
    end

    state :reserved do
      def can_be_proposed?
        false
      end
    end

  end


end


