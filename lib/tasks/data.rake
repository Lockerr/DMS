# encoding:UTF-8
namespace :data do
  task :import => :environment do

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

        c.model_id      = model.id
        c.line_id       = line.id
        c.color_id      = param[6]
        c.vin = param[5]
        c.interior_id   = param[7]
        c.price         = param[8].to_i
        c.options       = param[9]
        c.person_id     = Person.find_or_create_by_name(param[10])
        c.state         = param[10]
        c.arrival       = Time.parse(param[13]) if !param[13].empty?
        c.days_at_stock = (Time.now - c.arrival).to_i/60/60/24 if c.arrival
        c.description   = param[15]
        c.vp            = param[16]
        c.insurance     = param[17]

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
end