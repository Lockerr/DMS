# encoding: utf-8
class Contract < ActiveRecord::Base
  belongs_to :client

  serialize :gifts

  def generate
    result = []

    case type
      when 1 then
        result.push 'docx_template'
      else
        result['errors'] = {doctype => 'Неизвестный тип документа'}
    end
  end


  def price_kop
    if client.price.to_s.split('.').size == 2
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
            :price => Object.new.extend(ActionView::Helpers::NumberHelper).number_to_currency(client.cost, :unit => '', :separator => ',', :delimiter => " "),
            :price_w => RuPropisju.amount_in_words(client.cost, :rur).split(/\ /)[0..-2].join(' ').mb_chars.capitalize.to_s,
            :number => Time.now.year.to_s[2..3] + '/' + client.order.to_s[7..10],
            :top_date => I18n.localize(client.contract_date, :format => '%d %B %Y г.'),
            :person_name => client.name,
            :car_model_name => cleint.car.model.name,
            :prepay => Object.new.extend(ActionView::Helpers::NumberHelper).number_to_currency(client.prepay, :unit => '', :separator => ',', :delimiter => " "),
            :prepay_w => RuPropisju.amount_in_words(client.prepay, :rur).split(/\ /)[0..-2].join(' ').mb_chars.capitalize.to_s,
            :s_name => client.short_name,
            :birthday => client.birthday.strftime('%d.%m.%Y г.'),
            :address => client.adress,
            :p_id => "#{client.id_series.to_s.gsub(/(\d\d)(\d\d)/, '\1 \2')} #{person.id_number} #{person.id_dep}",
            :phones => client.phones.join(', '),
            :vin => client.car.vin,
            :color => client.car.color_id,
            :interior => client.car.interior_id,
            :production_year => client.car.prod_date.year,
            :gifts => client.gifts,
            :kop => client.price_kop

    }
  end



end
