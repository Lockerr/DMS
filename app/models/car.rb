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

  def self.rearrange_models
    Model.find_each do |model|
      next if model.name.scan('VIANO').any?
      next if model.name.empty?
      next if model.name.scan('VITO').any?
      model.update_attributes(name: model.name.scan(/([\w]{1,3}?)\s?(\d{2,3})|(VIANO)\s(\w+)/)[0].delete_if(&:nil?)[1])
    end
  end
  # after_create :check_for_mbclub_presence
  # after_update :check_for_mbclub_presence



  def interior
    if interior = Interior.find_by_code_and_klasse_id(interior_id, klasse_id)
      interior.desc
    else
      "ОШИБКА (НЕТ КОДА)"
    end    
  end
  
  def color
    if color = Color.find_by_code(color_id)
      "#{color.desc} #{color.metallic? ? 'металлик' : 'не металлик'}"
    else
      "ОШИБКА (НЕТ КОДА)"
    end    
  end


  
  def color_fact
    if color = Color.where(color_id)
      color.color
    else
      "ОШИБКА (НЕТ КОДА)"
    end    
  end
  self.include_root_in_json = false

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
    codes.each do |key, value|
      MOption.find_or_create_by_cars_orderno_and_opt_id(order, key, :opt_name => value, :opt_cost => 0)          
    end
  end

  def order_with_model
    "#{order}, #{model.name}"
  end

  def codes
    Hash[klasse.opts.where(:code => real_options).map{|i| [i.code,i.desc]}]
  end
end


