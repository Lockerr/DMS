#encoding: utf-8
class Mbr

  def self.nal
    
    file = Rails.root.join('nal.xls')
    book = Spreadsheet.open file
    puts 'opend' if book
    MCar.update_all :sold => 1
    Car.update_all :published => false
    published = []
    
    book.worksheets[0].each do |row|
      if row[12] == '+'
        if mcar = MCar.find_by_ordernum(row[1])
          attributes = {}
          attributes[:end_cost] = row[8].to_f
          attributes[:place] = row[11]
          mcar.update_attributes attributes
        elsif car = Car.find_by_order(row[1])
          puts car.inspect
          car.put_to_mbclub          
        end
        published.push row[1]
      end
    end
    
    puts published.inspect
    Car.where(:order => published).update_all :published => true
    MCar.where(:ordernum => published).update_all :sold => 0
  end


  def self.load_from_mbr
    require "selenium-webdriver"
    profile = Selenium::WebDriver::Firefox::Profile.new
    profile['browser.download.dir'] = Rails.root.join('tmp').to_s
    profile['browser.download.folderList'] = 2
    profile['browser.helperApps.neverAsk.saveToDisk'] = "application/vnd.ms-excel"

    driver = Selenium::WebDriver.for :firefox, :profile => profile
    puts 'start crawling'

    driver.navigate.to "https://portal.mercedes-benz.ru/irj/portal"
    driver.find_element(:id, 'logonuidfield').send_keys 'd5aansha'
    driver.find_element(:id, 'logonpassfield').send_keys 'Q@w3e4r5'
    driver.find_element(:class => 'urBtnStdNew').click

    puts 'loging ok'
    puts 'start switching to iframe'

    frame = driver.find_element(:id => 'ivuFrm_page0ivu1')
    driver.switch_to.frame frame
    puts 'start SITRI'
    
    wait = Selenium::WebDriver::Wait.new(:timeout => 20) # seconds
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

    wait.until { driver.find_element(:id => 'WD0139') }
    driver.find_element(:id => 'WD0139').click
    puts 'export true'
    
    sleep 5
    
    wait.until { driver.find_element(:id => 'WD013B-r') }
    
    sleep 1    
    driver.find_element(:id => 'WD013B-r').click
    sleep 1
    driver.find_element(:id => 'WD0139').click
    sleep 1
    driver.find_element(:id => 'WD013B').click
    sleep 1
    driver.find_element(:id => 'WD0139').click
    sleep 1
    driver.find_element(:id => 'WD013A').click
    
    sleep 15
    
    driver.close
  end

  def self.parse_from_mbr_file
    Dir.chdir(Rails.root.join('tmp'))
    file = File.new Rails.root.join('tmp', Dir.glob('*.xls')[0].to_s), 'r'
    puts file.inspect
    book = Hpricot.parse file.read
    counter = book.search('//tr').count
    puts counter
    (1..counter).each do |i|
      row = []
      if book.search('//tr')[i]
        row = book.search('//tr')[i].search('//td')
        row[31] = book.search('//tr')[i].search('//td')[31].inner_text
        

        opts = []
        opts += row[31].split('.')
        
        if (row[4].inner_text).split(/\s/)[0] == 'C200'
            modelname = row[4].inner_text.gsub('C200', 'C 200')
            klasse = "C"
        elsif (row[4].inner_text).split(/\s/)[0] == 'C250'
            modelname = row[4].inner_text.gsub('C250', 'C 250')
            klasse = "C"
        elsif (row[4].inner_text).split(/\s/)[0] == 'MERCEDES-BENZ'
          klasse = 'V'
          modelname = 'VIANO'
        else
            modelname = row[4].inner_text
            klasse = (row[4].inner_text).split(/\s/)[0]
        end


        attributes =
                {
                        :order => row[0].inner_text,
                        :vin => book.search('//tr')[i].search('//td')[1].inner_text,
                        :model => Model.find_or_create_by_name(row[4].inner_text.gsub(/"Особая с/,'').gsub(/Особая/,'')
                          .gsub(/BlueEFFICIENCY/,'')
                          .gsub(/BlueEFFICIENCY/,'')
                          .gsub(/Седан/,'')
                          .gsub(/MERCEDES-BENZ/, '')
                          .gsub(/Внедорожник/, '')
                          .gsub(/4MATIC/, '')
                          .gsub(/  /,' ')
                          .gsub(/ $/,'')
                          .gsub(/^ /,'')
                          .gsub(/  /,' ')

                          ),
                        :klasse_id => Klasse.find_by_name(klasse).id,
                        :color_id => row[29].inner_text,
                        :interior_id => row[30].inner_text,
                        :arrival => row[18].inner_text,
                        :engine_number => row[2].inner_text,
                        :real_options => opts,
                        :prod_date => row[10].inner_text

                }

        if car = Car.find_by_order(row[0].inner_text.to_s)
          car.update_attributes(attributes)
        else
          Car.create(attributes)
        end
      end

    end

  end
end
