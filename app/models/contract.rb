# encoding: utf-8
class Contract # < ActiveRecord::Base


  def attrs(client)
    {
            :price => Object.new.extend(ActionView::Helpers::NumberHelper).number_to_currency(client.cost, :unit => '', :separator => ',', :delimiter => " "),
            :price_w => RuPropisju.amount_in_words(client.cost, :rur).split(/\ /)[0..-2].join(' ').mb_chars.capitalize.to_s,
            :number => Time.now.year.to_s[2..3] + '/' + client.car.order.to_s[7..10],
            :top_date => I18n.localize(client.contract_date || DateTime.now, :format => '%d %B %Y г.'),
            :person_name => client.fio,
            :car_model_name => client.car.model.name,
            :car_model_name_2 => client.car.model.name,
            :prepay => Object.new.extend(ActionView::Helpers::NumberHelper).number_to_currency(client.prepay, :unit => '', :separator => ',', :delimiter => " "),
            :prepay_w => RuPropisju.amount_in_words(client.prepay, :rur).split(/\ /)[0..-2].join(' ').mb_chars.capitalize.to_s,
            :s_name => client.short_name,
            :birthday => client.birthday.strftime('%d.%m.%Y г.'),
            :address => client.adress,
            :p_id => "#{client.id_series.to_s.gsub(/(\d\d)(\d\d)/, '\1 \2')} #{client.id_number} #{client.id_dep}",
            :phones => client.phone1,
            :vin => client.car.vin,
            :color => client.car.color_id,            
            :interior => client.car.interior_id,
            :interior_name => (interior = Interior.find_by_code(client.car.interior_id) ? "#{interior.code} #{interior.desc}" : "ОШИБКА (НЕТ КОДА)"),
            :production_year => client.car.prod_date.year,
            #:gifts => client.gifts,
            :kop => client.price_kop

      } if client.valid?
  end


end
