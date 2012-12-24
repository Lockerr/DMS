# encoding: utf-8
class Contract # < ActiveRecord::Base


  def attrs(client)
    {
            :price => Object.new.extend(ActionView::Helpers::NumberHelper).number_to_currency(client.cost, :unit => '', :separator => ',', :delimiter => " "),
            :price_w => RuPropisju.amount_in_words(client.cost, :rur).split(/\ /)[0..-2].join(' ').mb_chars.capitalize.to_s,
            :number => Time.now.year.to_s[2..3] + '/' + client.car.order.to_s[7..10],
            :number_2 => Time.now.year.to_s[2..3] + '/' + client.car.order.to_s[7..10],
            :top_date => I18n.localize(client.contract_date || DateTime.now, :format => '%d %B %Y г.'),
            :top_date_2 => I18n.localize(client.contract_date || DateTime.now, :format => '%d %B %Y г.'),
            :person_name => client.fio,
            :car_model_name => client.car.model.name + ' седан',
            :car_model_name_2 => client.car.model.name + ' седан',
            :prepay => Object.new.extend(ActionView::Helpers::NumberHelper).number_to_currency(client.prepay, :unit => '', :separator => ',', :delimiter => " "),
            :prepay_w => RuPropisju.amount_in_words(client.prepay, :rur).split(/\ /)[0..-2].join(' ').mb_chars.capitalize.to_s,
            :s_name => client.short_name,
            :birthday => client.clientbirthday.strftime('%d.%m.%Y г.'),
            :address => client.client_adress,
            :p_id => "#{client.id_series.to_s.gsub(/(\d\d)(\d\d)/, '\1 \2')} #{client.id_number} #{client.id_dep} #{client.pas4.strftime('%d.%m.%Y') if client.pas4}",
            :phones => client.phone1,
            :vin => client.car.vin,
            :color => client.car.color_id,            
            :interior => client.car.interior_id,
            :interior_name => client.car.interior.gsub(/'/,''),
            :color_name => client.car.color,
            :production_year => client.car.prod_date.year,
            #:gifts => client.gifts,
            :kop => client.price_kop

      } if client.valid?
  end


end
