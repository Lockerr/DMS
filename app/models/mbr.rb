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

    book = Excel.new Dir.glob('*.xls')[0].to_s

    book.default_sheet = book.sheets[0]

    2.upto(book.last_row) do |row|
      book.cell(row, 13)

      opts = book.cell(row, 32).split('.')

      puts book.cell(row, 5)
      puts book.cell(row, 1)

      next if book.cell(row,5).match 'Sprinter'
      next if book.cell(row,5).match 'VITO'
      next if book.cell(row,5).match 'VIANO'
      # def parse_array
      #   re = /^(\w{1,3}?)\s?(\d{1,3})\s?([CDI|CGI|4MATIC]+\s?[CDI|CGI|4MATIC]+)?(.*)?$/
      #   CARS.each do |k, v|
      #     next if book.cell(row,5).match 'Sprinter'
      #     next if book.cell(row,5).match 'VITO'
      #     model_name = book.cell(row, 5).scan(re)[0][1..2].join(' ')
      #     model.find_or_create_by_name(model_name)

      #   end
      # end
      re = /^(\w{1,3}?)\s?(\d{1,3})\s?([CDI|CGI|4MATIC]+\s?[CDI|CGI|4MATIC]+)?(.*)?$/
      klasse_name = book.cell(row, 5).scan(/([\w]{1,3}?)\s?(\d{2,3})|(VIANO)\s(\w+)/)[0].delete_if(&:nil?)[0]
      klasse_name = 'V' if (klasse_name == 'VIANO' or klasse_name == 'VITO' or klasse_name == 'Sprinter')
      next if klasse_name == 'V'
      puts book.cell(row, 5).scan(re)[1..2]
      model_name = book.cell(row, 5).scan(re)[0][1..2].join(' ')

      puts klasse_name
      puts model_name

      raise Error unless klasse_name
      raise Error unless model_name

      klasse = Klasse.find_by_name(klasse_name)

      unless model = klasse.models.find_by_name(model_name)
        model = klasse.models.create!(name: model_name)
      end

      state = case book.cell(row, 6)
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
                      :order => book.cell(row, 1),
                      :vin => book.cell(row, 2),
                      :model_id => model.id,
                      :klasse_id => klasse.id,
                      :color_id => book.cell(row, 30),
                      :interior_id => book.cell(row, 31),
                      :arrival => book.cell(row, 19),
                      :engine_number => book.cell(row, 3),
                      :real_options => opts,
                      :prod_date => book.cell(row, 11)

              }
      # gets

      if car = Car.find_by_order(book.cell(row, 1).to_s)
        car.update_attributes(attributes)
      else
        Car.create!(attributes)
      end

    end

  end


end
