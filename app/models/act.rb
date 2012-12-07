#encoding: utf-8
class Act# < ActiveRecord::Base
  #belongs_to :car
  #belongs_to :person

  def properties
    REXML::Document.new File.new(Rails.root.join('assets', 'act_template', 'docProps', 'custom.xml'), 'r').read
  end

  def body
    file = File.new Rails.root.join('assets', 'act_template', 'word', 'document.xml'), 'r'
    REXML::Document.new file.read
  end

  def price_kop(price)
    if price.to_s.split('.').size == 2
      kopejki = price.to_s.split('.')[1]
      propis = RuPropisju.kopeek(kopejki.to_i)
      if kopejki.to_i < 10
        propis = '0' + propis
      end

    else
      propis = '00 копеек'
    end
    if propis.to_i == 0
      propis = '00 копеек'
    end
    propis
  end

  def attrs(client)
    {
            :contract_kp_number => Time.now.year.to_s[2..3] + client.car.order.to_s[2..-1],
            :contract_kp_date => Time.now.year.to_s[2..3] + '/' + client.car.order.to_s[7..10],

            :person_name => client.fio,
            :person_name_2 => client.fio,
            :person_birthday => client.clientbirthday.strftime('%d.%m.%Y'),
            :person_address => client.client_adress,
            :person_id => "#{client.id_series.to_s.gsub(/(\d\d)(\d\d)/, '\1 \2')} #{client.id_number} #{client.id_dep} #{client.pas4.strftime('%d.%m.%Y') if client.pas4}",
            :person_s_name => client.short_name,
            :kop => price_kop(client.cost),
            :car_model_name => client.car.model.name,
            :car_vin => client.car.vin,
            :car_prod_year => client.car.prod_date.year,
            :car_engine_number => client.car.engine_number,
            
            :car_pts => 'ПТС (ОШИБКА)',

            :chasis_vin => client.car.klasse.name == 'G' ? client.car.vin : 'ОТСУТСТВУЕТ',
            :body_vin => client.car.klasse.name == 'G' ? 'ОТСУТСТВУЕТ' : client.car.vin,

            :car_price => Object.new.extend(ActionView::Helpers::NumberHelper).number_to_currency(client.cost, :unit => '', :separator => ',', :delimiter => " "),
            :car_price_w => RuPropisju.amount_in_words(client.cost, :rur).split(/\ /)[0..-2].join(' ').mb_chars.capitalize.to_s,
            :car_nds => Object.new.extend(ActionView::Helpers::NumberHelper).number_to_currency(client.cost * 18.0 / 118.0, :unit => '', :separator => ',', :delimiter => " "),


    }
  end


  def prop
    doc = self.properties

    while doc.root.delete_element "//property"
      true
    end

    counter = 2
    docbody = self.body
    keys = attrs.keys


    for key in attrs.keys
      element = REXML::Element.new('property')
      element.add_attribute 'fmtid', '{D5CDD505-2E9C-101B-9397-08002B2CF9AE}'
      element.add_attribute 'pid', counter
      element.add_attribute 'name', key

      ne = REXML::Element.new 'vt:lpwstr'
      ne.add_text attrs[key].to_s || ' '

      element.add_element ne

      doc.root.add_element element

      counter += 1
    end

    for key in keys
      Rails.logger.info key.inspect
      docbody.root.elements["*/w:p/w:fldSimple[@w:instr=' DOCPROPERTY  #{key.to_s}  \\* MERGEFORMAT ']"].elements['w:r'].elements['w:t'].text = (attrs[key].to_s || ' ')
    end

    temp = Rails.root.join 'tmp', Time.now.to_i.to_s

    Dir.mkdir temp

    source = Rails.root.join('assets', 'act_template')

    system("cp -r #{source}/. #{temp}  ")

    file = File.new Rails.root.join('tmp', temp, 'docProps', 'custom.xml'), 'w'
    file.write doc.to_s
    file.close

    file = File.new Rails.root.join('tmp', temp, 'word', 'document.xml'), 'w'
    file.write docbody.to_s
    file.close

    system("cd #{temp} && zip -r act.docx .")

    temp
  end
end
