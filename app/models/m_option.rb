#encoding: utf-8
class MOption < ActiveRecord::Base
  # attr_accessible :title, :body
  set_table_name 'cars_options'
  establish_connection(
    :adapter => 'mysql2',
    :encoding => 'utf8',
    :database => 'mbclub74',
    :host => 'mbclub74.ru',
    :username => 'lynx',
    :password => 'lyna123'

    )
  
  def self.update_options

  end

  def self.write_options
    transaction do
      for car in Car.all
        car.codes.each do |key, value|
          unless value == 'Опция неизвестна'
              MOption.find_or_create_by_cars_orderno_and_opt_id(car.order, key, :opt_name => value, :opt_cost => 0)          
          end
        end
      end
    end
  end
  

  def self.empty_options
    for car in Car.all
      MOption.where(:cars_orderno => car.order).destroy_all
    end

  end



end
