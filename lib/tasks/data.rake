# encoding:UTF-8
namespace :data do
  task :presence, :file, :needs => :environment do |t, file|
    puts "file is #{file[:file]}"
    file = file[:file]
    book = Spreadsheet.open file
    puts 'opend' if book
    MCar.update_all :sold => 1
    Car.update_all :published => false
    published = []
    book.worksheets[0].each do |row|
      if row[12] == '+'
        # if car = Car.find_by_order(row[1])
        #   car.price = row[8].to_f
        #   car.published = true
        #   puts "car  - #{car.order} - #{row[12].inspect} = #{row[12] == '+' ? true : false}"

        #   car.state = row[11]
        #   # puts attributes = {:price => row[8].to_f, :state => row[11], :published => (row[12] == '+' ? true : false)}
        #   car.save
        #   car.reload
       
        #   if mcar = MCar.find_by_ordernum(row[1])
        #     mcar.end_cost = row[8].to_f
        #     mcar.sold = 0
        #     mcar.place = row[11]
        #     mcar.save

        #   end
        # end
        if mcar = MCar.find_by_ordernum(row[1])
          attributes = {}
          attributes[:end_cost] = row[8].to_f
          attributes[:place] = row[11]
          mcar.update_attributes attributes
        elsif car = Car.find_by_order(row[1])
          car.put_to_mbclub          
        end

          

        end
        published.push row[1]
      end
    end
    puts published.inspect
    MCar.where(:ordernum => published).update_all :sold => 0
  end
  
  task :state => :environment do
    require 'spreadsheet'

    def clear(value)
      value.gsub!(/(Blue)(EFFICIENCY)/, '')
      value.gsub!(/(Особая серия)/, 'OC')
      value.gsub!(/(Внедорожник)/, '')
      value.gsub!(/(Седан)/, '')
      value.gsub!(/(Особая)/, 'ОС')
      #value.gsub!(/(\(длинная база\))/, '')
      value.gsub!(/(Mercedes\-Benz)/, '')
      value.gsub!(/(\t)/, ' ')
      value.gsub!(/(\s)/, ' ')
      value.gsub!(/(\ \ )/, ' ')
      value.gsub!(/(\s\s)/, ' ')
      value.gsub!(/(^\s)/, '')
      value.gsub!(/(\w)(\d\d\d)/, '\1 \2')
      value.gsub!(/(Coupe)/, 'Купе')
      value


    end

    book = Spreadsheet.open 'tmp/export.xls'
    for ws in book.worksheets

      state = 1
      state = 0 if row[0] != 'Дата продажи а/м дилеру'
      state = 0 if row[2] != 'Внешний номер ТранспортСредств'
      state = 0 if row[3] != 'VIN'
      state = 0 if row[30] != 'Название модели а/м'
      state = 0 if row[31] != 'Цвет кузова а/м'
      state = 0 if row[32] != 'Обивка'

      ws.each do |row|
        unless row[0] == 'Дата продажи а/м дилеру'
          puts clear(row[30])
          puts "#{row[2]}\t#{row[3]}\t#{clear(row[30])}\t#{row[31]} #{row[32]} #{row[39]} #{row[41]}"
          opts = []
          if row[34]

            opts += row[33].split('.') + row[34].split('.')

          else
            opts += row[33].split('.')

          end
          puts opts.inspect
          attributes = {
              :order         => row[2],
              :vin           => row[3],
              :model         => Model.find_or_create_by_name(clear(row[30])),
              :klasse_id     => Klasse.find_by_name(clear((row[30]).split(/\s/)[0])).id,
              :color_id      => row[31],
              :interior_id   => row[32],
              :arrival       => row[39],
              :engine_number => row[41],
              :real_options  => opts
          }
          if car = Car.find_by_order(row[2].to_s)
            puts opts.class
            car.update_attributes(attributes)
          else
            puts opts.size
            Car.create(attributes)

            puts Car.last.real_options.size == opts.size
          end
        end
      end
    end
  end

  task :import_codes => :environment do

    book = Spreadsheet.open 'temp.xls'
    puts book.worksheets.count
    for ws in book.worksheets
      puts ws.name
      puts ws.rows
      ws.each do |row|
        if row[0] != nil and row[1] != nil

          Opt.create :pseudo_klasse => ws.name, :code => row[0], :desc => row[1]

        end
        puts row[0]
        puts row[1]
      end
    end
  end


  task :import => :environment do
    result = []
    for car in Car.select([:klasse_id, :real_options])
      car.real_options.each do |code|
        puts code
        result.push "#{car.klasse.name} \t #{code} \t Оция неизвестна" if Opt.where(:klasse_id => car.klasse_id, :code => code.to_s).empty?
      end
    end
    result.uniq!
    #"0 0152433239"
    #"1 C"
    #"2 C 180 CGI"
    #"3 C"
    #"4 WDD2040491A590140"
    #"5 197"
    #"6 721"
    #"7 1,480,000"
    #"8 ОС + 260 + 527 + 950"
    #"9 Тест-драйв / Максим до 12.12"
    #"10 Склад"
    #"11 10 Aug"
    #"12 176"
    #"13 Подарки на 50.000р."
    #"14 +"
    #"15 И"
    #"16 И"

    doc = Hpricot.parse(File.read "/home/anton/Nalichie.xml")

    for row in ((doc/:worksheet)[0]/:row)
      param = (row/:cell).map { |i| (i/:data).inner_text }
      puts param
      unless param[0].empty?
        c       = Car.new
        c.order = param[1]
        k       = param[3].split(' ')[0]

        if klasse = Klasse.find_by_name(k)
          c.klasse_id = klasse.id
        elsif k == 'Viano'

          klasse      = Klasse.find_by_name('V')
          c.klasse_id = klasse.id
        elsif k == 'ML'
          klasse      = Klasse.find_by_name('M')
          c.klasse_id = klasse.id

        end

        model = klasse.models.find_or_create_by_name(param[3])
        line  = Line.find_or_create_by_name(param[4])

        c.model_id    = model.id
        c.line_id     = line.id
        c.color_id    = param[6]
        c.vin         = param[5]
        c.interior_id = param[7]
        c.price       = param[8].to_i
        c.options     = param[9]
        c.person_id   = Person.find_or_create_by_name(param[10])
        c.state       = param[10]
        c.arrival = Time.parse(param[13]) if !param[13].empty?
        c.days_at_stock = (Time.now - c.arrival).to_i/60/60/24 if c.arrival
        c.description = param[15]
        c.vp          = param[16]
        c.insurance   = param[17]

        case param[18]
          when "Ю"
            c.manager_id = 1
          when "Н"
            c.manager_id = 4
          when "В"
            c.manager_id =3
          when "М"
            c.manager_id =5
          when "И"
            c.manager_id =2


        end

        case param[19]
          when "Ю"
            c.payment = 1
          when "Н"
            c.payment = 4
          when "В"
            c.payment = 3
          when "М"
            c.payment = 5
          when "И"
            c.payment = 2


        end

        c.save
      end
    end

    #  for param in
    #  params = d.split('==')
    #    c       = Car.new
    #    c.order = params[0]
    #    k       = param[2].split(' ')[0]
    #
    #    if klasse = Klasse.find_by_name(k)
    #      c.klasse_id = klasse.id
    #    elsif k == 'Viano'
    #      klasse      = Klasse.find_by_name('V')
    #      c.klasse_id = klasse.id
    #    end
    #
    #    model = klasse.models.find_or_create_by_name(param[2])
    #    line  = Line.find_or_create_by_name(param[3])
    #  end
    #end
    ##doc[4].get_elements('Worksheet')[0].get_elements('Table')[0].get_elements('Row')[1].get_elements('Cell')[1].get_elements('Data')[0].conget_text
    #

  end
  def qwe
    browser = Watir::Browser.new :firefox
    browser.goto 'https://portal.mercedes-benz.ru/'
    browser.text_field(:id => 'logonuidfield').set 'd5aansha'
    browser.text_field(:id => 'logonpassfield').set '1q2w3e$R'
    browser.element(:class => 'urBtnStdNew').click
    browser.div(:id=>"some_div").exists? sleep 1
  end

  def omg_codes
    Code.create(:klasse_id => 'A', :code => 'b', :desc => 'c')

  end
end