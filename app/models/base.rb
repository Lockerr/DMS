class Base
  require "selenium-webdriver"

  def initialize
    profile = Selenium::WebDriver::Firefox::Profile.new
    profile['browser.download.dir'] = Rails.root.join('tmp').to_s
    profile['browser.download.folderList'] = 2
    profile['browser.helperApps.neverAsk.saveToDisk'] = "application/vnd.ms-excel"
    @driver = Selenium::WebDriver.for :firefox, :profile => profile
    @wait = Selenium::WebDriver::Wait.new(:timeout => 20)
  end

  def navigate
    if @driver.navigate.to("https://portal.mercedes-benz.ru/irj/portal")
      puts 'navigate - ok' 
      return true
    else
      return false
    end
  end

  def login
    driver.find_element(:id, 'logonuidfield').send_keys 'd5aansha'
    pwds = %w(Selenium123$ Hidra123$)
    driver.find_element(:id, 'logonpassfield').send_keys 'Hidra123$'
    if driver.find_element(:class => 'urBtnStdNew').click
      puts 'login - ok'
    end
    true
  end

  def driver
    @driver
  end

  def wait
    @wait
  end

  def process
    

    puts 'start switching to iframe'

    frame = driver.find_element(:id => 'ivuFrm_page0ivu1')
    driver.switch_to.frame frame
   
     
    wait.until { driver.find_element(:class_name => "SItreeText") }

    driver.find_elements(:class_name => "SItreeText")[1].click

    driver.switch_to.default_content

    wait.until { driver.find_element(:id => 'ivuFrm_page0ivu1') }
          
    driver.switch_to.frame driver.find_element(:id => 'ivuFrm_page0ivu1')
    
    wait.until { driver.find_element(:id => 'isolatedWorkArea') }
    driver.switch_to.frame driver.find_element(:id => 'isolatedWorkArea')
     begin
      elements = wait.until { driver.find_element(:class => 'urBtnCnt') }
    rescue
      begin
        elements = wait.until { driver.find_elements(:class => 'urBtnCnt') }
      rescue
        puts 'fails waiting'    
      end
      puts 'fails waiting'    
    end
    puts 'end waiting'
    
    driver.switch_to.default_content
    driver.switch_to.frame driver.find_element(:id => 'ivuFrm_page0ivu1')
    driver.switch_to.frame driver.find_element(:id => 'isolatedWorkArea')

    driver.find_element(:class => 'urBtnCnt').click
  end

  def click_export
    wait.until { driver.find_element(:id => 'WD0147') }
    driver.find_element(:id => 'WD0147').click
  end

  def click_export_to_xls
    wait.until { driver.find_element(:id => 'WD0148') }
    driver.find_element(:id => 'WD0148').click
  end

  def download
    navigate
    login
    process
    click_export
    click_export_to_xls
  end

end
