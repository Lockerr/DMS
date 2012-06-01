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


  def self.mbr
    require "selenium-webdriver"
    profile = Selenium::WebDriver::Firefox::Profile.new
    profile['browser.download.dir'] = "/home/user/tmp/mbr/down/"
    profile['browser.download.folderList'] = 2
    profile['browser.helperApps.neverAsk.saveToDisk'] = "application/vnd.ms-excel"


    driver = Selenium::WebDriver.for :firefox, :profile => profile
    puts 'start crawling'
    begin

      driver.navigate.to "https://portal.mercedes-benz.ru/irj/portal"
    rescue
      puts 'fail to start selenium'
    end
    begin
      driver.find_element(:id, 'logonuidfield').send_keys 'd5aansha'
      driver.find_element(:id, 'logonpassfield').send_keys '%T$R3e2w1q'
      driver.find_element(:class => 'urBtnStdNew').click
      puts 'loging ok'
    rescue
      puts 'fails to login'
    end
    puts 'start switching to iframe'
    begin
      frame = driver.find_element(:id => 'ivuFrm_page0ivu1')
      driver.switch_to.frame frame
    rescue
      puts 'fail to find iframe'
    end
    puts 'start SITRI'
    begin
      wait = Selenium::WebDriver::Wait.new(:timeout => 15) # seconds
      wait.until {
        driver.find_element(:class_name => "SItreeText")
        driver.find_elements(:class_name => "SItreeText")[1].click
      }

    rescue
      puts 'fail to find SITreeText'
    end

    driver.switch_to.default_content
    puts 'switching back'
    wait = Selenium::WebDriver::Wait.new(:timeout => 15) # seconds
    begin
      wait.until {

        driver.find_element(:id => 'ivuFrm_page0ivu1')
        driver.switch_to.frame driver.find_element(:id => 'ivuFrm_page0ivu1')
        driver.switch_to.frame driver.find_element(:id => 'isolatedWorkArea')
        driver.find_elements(:class => 'urBtnCntTxt')[1].click
      }
    rescue
      driver.switch_to.default_content
      driver.find_element(:id => 'ivuFrm_page0ivu1')
      driver.switch_to.frame driver.find_element(:id => 'ivuFrm_page0ivu1')
      driver.switch_to.frame driver.find_element(:id => 'isolatedWorkArea')
      driver.find_elements(:class => 'urBtnCntTxt')[1].click
    end

    wait = Selenium::WebDriver::Wait.new(:timeout => 50) # seconds
    wait.until {
      puts 'export true'
      driver.find_element(:id => 'WD0138')
      driver.find_element(:id => 'WD0138').click
    }
    wait.until {
      puts 'export to xcel true'
      driver.find_element(:id => 'WD0139')
      driver.find_element(:id => 'WD0139').click
    }
    Dir.chdir("/home/user/tmp/mbr/down/")
    file = File.new "/home/user/tmp/mbr/down/#{Dir.glob('*.xls')[-1]}", 'r'
    puts file.inspect
    parse_cars(file)

  end

  def parse_cars(file)
    book = Hpricot.parse file.read
    counter = book.search('//tr').count
    puts counter
    (1..counter).each do |i|
      row = []
      if book.search('//tr')[i]
        row[2] = book.search('//tr')[i].search('//td')[2].inner_text
        row[3] = book.search('//tr')[i].search('//td')[3].inner_text
        row[9] = book.search('//tr')[i].search('//td')[9].inner_text
        row[30] = book.search('//tr')[i].search('//td')[30].inner_text
        row[31] = book.search('//tr')[i].search('//td')[31].inner_text
        row[32] = book.search('//tr')[i].search('//td')[32].inner_text
        row[39] = book.search('//tr')[i].search('//td')[39].inner_text
        row[41] = book.search('//tr')[i].search('//td')[41].inner_text
        row[34] = book.search('//tr')[i].search('//td')[34].inner_text
        row[33] = book.search('//tr')[i].search('//td')[33].inner_text

        opts = []
        row[34] ? opts += row[33].split('.') + row[34].split('.') : opts += row[33].split('.') if row[34]

        attributes =
                {
                        :order => row[2],
                        :vin => row[3],
                        :model => Model.find_or_create_by_name(clear(row[30])),
                        :klasse_id => Klasse.find_by_name(clear((row[30]).split(/\s/)[0])).id,
                        :color_id => row[31],
                        :interior_id => row[32],
                        :arrival => row[39],
                        :engine_number => row[41],
                        :real_options => opts,
                        :prod_date => row[9]
                }

        if car = Car.find_by_order(row[2].to_s)
          car.update_attributes(attributes)
        else
          Car.create(attributes)
        end
      end

    end
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
