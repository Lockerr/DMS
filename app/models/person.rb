class Person < ActiveRecord::Base

  has_many :communications
  has_and_belongs_to_many :orders, :class_name => 'Car'
  belongs_to :manager
  has_many :cars
  has_and_belongs_to_many :models, :uniq => true
  has_many :contracts
  has_many :proposals
  has_many :dkps

  validates_presence_of :name

  serialize :phones, Array

  validates_uniqueness_of :id_number, :scope => :id_series
  validates_uniqueness_of :phones

  attr_accessor :first_name, :second_name, :third_name
  attr_accessor :phone
  before_save :flatten_phones
  before_update :flatten_phones
  after_save :write_logs

  def first_name
    name.split(' ')[0]
  end

  def second_name
    name.split(' ')[1] if name.split(' ').size > 1
    end

  def third_name
    name.split(' ')[2] if name.split(' ').size > 2
  end

  def flatten_phones
    if phones.class == Array
      phones.each { |i| i.gsub!(/\s/, '') }
    elsif phones.class == Hash
      phones = phones.values
      phones.each { |i| i.gsub!(/\s/, '') }
    end
  end

  def name_with_phone
    "#{name} #{(phones and !phones.empty?) ? phones.join(' ,') : ''}"
  end

  def phone=(value)
    raise value.inpect
  end

  def write_logs
    Log.create(:model_name => 'person', :parameters => self.changes, :object_id => self.id, :user_id => User.current_user)
  end

  def short_name
    n = name.split(/(\s|\.)/).delete_if { |i| i == '.' || i == ' ' }

    if n.count == 3
      "#{n[0]} #{n[1][0]}. #{n[2][0]}."
    else
      self.name
    end
  end

end
