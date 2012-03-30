#encoding: utf-8
class Act < ActiveRecord::Base
  belongs_to :car
  belongs_to :person

  def properties
    REXML::Document.new File.new(Rails.root.join('assets', 'act_template', 'docProps', 'custom.xml'), 'r').read
  end

  def body
    file = File.new Rails.root.join('assets', 'act_template', 'word', 'document.xml'), 'r'
    REXML::Document.new file.read
  end

  def price_kop
    if self.price.to_s.split('.').size == 2
      kopejki = self.price.to_s.split('.')[1]
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

  def attrs
    {
            :contract_kp_number => car.contract ? car.contract.number : '!!!!! НЕТ НОМЕРА !!!!!',
            :contract_kp_date => car.contract ? car.contract.date : '!!!!! НЕТ ДАТЫ !!!!!',

            :person_name => person.name,
            :person_name_2 => person.name,
            :person_birthday => person.birthday.strftime('%d.%m.%Y'),
            :person_address => person.address,
            :person_id => "#{person.id_series.to_s.gsub(/(\d\d)(\d\d)/, '\1 \2')} #{person.id_number} #{person.id_dep}",
            :person_s_name => self.person.short_name,
            :kop => price_kop,
            :car_model_name => car.model.name,
            :car_vin => car.vin,
            :car_prod_year => car.prod_date.year,
            :car_engine_number => car.engine_number,
            :car_pts => car_pts,

            :chasis_vin => car.klasse.name == 'G' ? car.vin : 'ОТСУТСТВУЕТ',
            :body_vin => car.klasse.name == 'G' ? 'ОТСУТСТВУЕТ' : car.vin,

            :car_price => Object.new.extend(ActionView::Helpers::NumberHelper).number_to_currency(price, :unit => '', :separator => ',', :delimiter => " "),
            :car_price_w => RuPropisju.amount_in_words(price, :rur).split(/\ /)[0..-2].join(' ').mb_chars.capitalize.to_s,
            :car_nds => Object.new.extend(ActionView::Helpers::NumberHelper).number_to_currency(price * 18.0 / 118.0, :unit => '', :separator => ',', :delimiter => " "),
            #:car_color_id => car.color_id,
            #:car_interior_id => car.interior_id,

            #:car_klasse => car.klasse.name


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
