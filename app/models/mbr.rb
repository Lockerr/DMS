#encoding: utf-8
class Mbr
  def self.analyze(num)
    if car = Car.where(:order => num).first
      print 'exist in cars' 
      print 'and published' if car.published
    end

    if car = MCar.find_by_ordernum(num)
      print 'exist in mbclub' 
      prind ' and published' if car.sold == 0
    end
  end

  def self.set_presence
  end
  
  def self.source
    if Rails.env.development?
      '/home/anton/shared/!Отдел продаж/Журналы/Nalichie.xlsx'
    else
      '/home/user/shared/!Отдел продаж/Журналы/Nalichie.xlsx'
    end
  end

  def self.check_nal_by_order(order_number)
    file = Rails.root.join('tmp', 'file.xlsx')
    FileUtils.cp source, file


    book = Excelx.new(file.to_s)

    result = nil

    puts 'opend' if book
    Rails.logger.info 'opend' if book
    published = []

    book.default_sheet = book.sheets[0]

    1.upto(book.last_row) do |row|
      if book.cell(row,2) == order_number
        result = book.row(row)
      end
      puts row
    end
    result
  end


  def self.update_price
    source
    
    file = Rails.root.join('tmp', 'file.xlsx')
    FileUtils.cp source, file


    book = Excelx.new(file.to_s)


    puts 'opend' if book
    Rails.logger.info 'opend' if book
    published = []

    book.default_sheet = book.sheets[0]

    1.upto(book.last_row) do |row|
      if book.cell(row, 13) == '+'
        if car = Car.find_by_order(book.cell(row,2))
          car.update_attributes gpl: book.cell(row,9).to_f
        end
      end
    end
  end

  def self.nal
    source = '/home/user/shared/!Отдел продаж/Журналы/Nalichie.xlsx'

    file = Rails.root.join('tmp', 'file.xlsx')
    FileUtils.cp source, file


    book = Excelx.new(file.to_s)


    puts 'opend' if book
    Rails.logger.info 'opend' if book
    published = []

    book.default_sheet = book.sheets[0]

    1.upto(book.last_row) do |row|
      if book.cell(row, 13) == '+'
        puts book.cell(row, 13)
        puts "#{book.cell(row,2)} - #{book.cell(row,12)} - #{book.cell(row,7)} - #{book.cell(row,8)}"
        Rails.logger.info "#{book.cell(row,2)} - #{book.cell(row,12)} - #{book.cell(row,7)} - #{book.cell(row,8)}"

        if mcar = MCar.find_by_ordernum(book.cell(row,2))
          attributes = {}
          attributes[:place] = book.cell(row,12)
          attributes[:color] = book.cell(row,7).to_s.gsub('.0', '')
          attributes[:inter] = book.cell(row,8).to_s.gsub('.0','')
          attributes[:end_cost] = book.cell(row,9).to_f
          mcar.update_attributes attributes

          if car = Car.find_by_order(book.cell(row,2))
            car.update_attributes gpl: book.cell(row,9).to_f
          end

        elsif car = Car.find_by_order(book.cell(row,2))
          puts car.inspect
          car.put_to_mbclub
        end

        published.push book.cell(row,2)


      end
    end

    MCar.update_all :sold => 1
    Car.update_all :published => false

    Car.where(:order => published).update_all :published => true
    MCar.where(:ordernum => published).update_all :sold => 0

  end



  def self.anal(index)
    
    file = File.new('/home/user/shared/!Отдел продаж/Журналы/Nalichie.xls', 'r')
    book = Spreadsheet.open file
    puts 'opend' if book
    published = []

    book.worksheets[0].each do |row|
      if row[12] == '+'
        puts row[index].to_f
        
      end
    end    
    
  end

  def self.update_cost
    file = File.new('/home/user/shared/!Отдел продаж/Журналы/Nalichie.xls', 'r')
    book = Spreadsheet.open file
    puts 'opend' if book
    published = []

    book.worksheets[0].each do |row|
      if row[12] == '+'
        MCar.where(:ordernum => row[1]).update_all(:end_cost => row[8].to_f)        
      end
    end    
  end

  def self.get_cars_by_class
    file = File.new('/home/user/shared/!Отдел продаж/Журналы/Nalichie.xls', 'r')

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
    # driver.find_element(:id, 'logonpassfield').send_keys 'Q@w3e4r5'
    # driver.find_element(:id, 'logonpassfield').send_keys 'Kfgfnf%$321'
    driver.find_element(:id, 'logonpassfield').send_keys 'Selenium123$'
    
    

    
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

    puts 'export true'
    sleep 5
    wait.until { driver.find_element(:id => 'WD0147') }

    sleep 1
    driver.find_element(:id => 'WD0147').click
    sleep 5
    driver.find_element(:id => 'WD0149').click
    sleep 5
    driver.find_element(:id => 'WD0139').click
    sleep 1
    driver.find_element(:id => 'WD013B').click
    sleep 1
    driver.find_element(:id => 'WD0139').click
    sleep 1
    driver.find_element(:id => 'WD013A').click

    sleep 10
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
        opts = row[31].split('.')

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

        state = case row[5].inner_text  
          when 'At Customer' then '1_В наличии'
          when 'In Transit to Customer' then '2_Пути'
          when 'Склад ОтветХранения' then '2_Склад ОтветХранения'
          when 'д. Чашниково' then '3_Чашниково'
          when 'Factory' then '3_Фабрика'
          when 'Paldiski' then '3_Палдиски'

          else '3_статус не известен'
        end

        attributes = {
                        :state => state,
                        :order => row[0].inner_text,
                        :vin => book.search('//tr')[i].search('//td')[1].inner_text,
                        :model => Model.find_or_create_by_name(row[4].inner_text
                          .gsub(/"Особая с/,'')
                          .gsub(/Особая/,'')
                          .gsub(/BlueEFFICIENCY/,'')
                          .gsub(/Седан/,'')
                          .gsub(/MERCEDES-BENZ/, '')
                          .gsub(/Внедорожник/, '')
                          .gsub(/4MATIC/, '')
                          .gsub(/  /,' ')
                          .gsub(/ $/,'')
                          .gsub(/^ /,'')
                          .gsub(/  /,' ')
                          .gsub('ОС','')
                          .gsub(/\s+$/,'')

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
