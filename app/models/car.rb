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

  before_update :write_logs

  default_scope includes(:manager, :model, :person, :klasse, :line, :payment, :contract)

  self.include_root_in_json = false


  def mbr
    require "selenium-webdriver"
    begin
      driver = Selenium::WebDriver.for :firefox
      driver.navigate.to "https://portal.mercedes-benz.ru/irj/portal"
    rescue
      puts 'fail to start selenium'
    end
    begin
    driver.find_element(:id, 'logonuidfield').send_keys 'd5aansha'
    driver.find_element(:id, 'logonpassfield').send_keys '1q2w3e$R'
    driver.find_element(:class => 'urBtnStdNew').click
    rescue
      puts 'fails to login'
    end

    begin
      frame = driver.find_element(:id => 'ivuFrm_page0ivu1')
      driver.switch_to.frame frame
    rescue
      puts 'fail to find iframe'
    end

    begin
      wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
      wait.until { driver.find_element(:class_name => "SItreeText") }
    rescue
      puts 'fail to find SITreeText'
    end

    begin
      driver.find_elements(:class_name => "SItreeText")[1].click
    rescue
      puts 'clickfail'
    end







    driver
  end


  def write_logs(object=nil)
    if self.changes.any?
      Log.create(:model_name => 'car', :parameters => self.changes, :object_id => self.id, :user_id => User.current_user)
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
