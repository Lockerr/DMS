#encoding: utf-8
class MCar < ActiveRecord::Base
  
  after_create :validate_codes
  after_update :validate_codes

  establish_connection(
    :adapter => 'mysql2',
    :encoding => 'utf8',
    :database => 'mbclub74',
    :host => 'mbclub74.ru',
    :username => 'lynx',
    :password => 'lyna123'

    )
  set_table_name 'mbclub74.cars'
  
  scope :unsold, where(:sold => 0)
  scope :a, where(:class => 'A')
  scope :c, where(:class => 'C')
  scope :b, where(:class => 'B')
  scope :e, where(:class => 'E')
  scope :v, where(:class => 'V')
  

  bad_attribute_names :class

  def write_options
  
  end

  def class_name= value
    self[:class] = value
  end

  def class_name
    self[:class]
  end

  def car
    Car.find_by_order(ordernum)
  end

  def add_picture(picture)
    pictures = pics.scan(/".*?"/).map{|i| i.gsub(/\"/, '')}
    pics = "a:#{pictures.size}:{"
    pictures += picture

    for picture in pictures
      pics += "i:#{pictures.index(picture)};s:#{picture.size}:\"#{picture}\";"
    end
    
    pics += "}"    
  end

  def validate_codes
      collection = []

      collection.push color.to_s if color != 0 and color
      collection.push inter.to_s if inter != '0' and inter

      wrong = MOption.where(:cars_orderno => ordernum, :opt_id => collection)
      code = wrong.group(:opt_id).map(&:opt_id).uniq.first
      puts ordernum
      puts code
      puts color
      puts inter

      wrong.destroy_all
      
      klasse = Klasse.find_by_name class_name

      if interior = Interior.where(:klasse_id => klasse).find_by_code(inter)
        interior_description = interior.desc
      else
        interior_description = 'Позвоните нам!'
      end

      if _color = Color.find_by_code(color)
        color_description = _color.desc
      else
        color_description = 'Позвоните нам!'
      end
      

      __interior = MOption.new(:cars_orderno => ordernum, :opt_id => inter, :opt_name => interior_description, :opt_cost => 0)
      __color = MOption.new(:cars_orderno => ordernum, :opt_id => color, :opt_name => color_description, :opt_cost => 0)
      if klasse
        if _option = klasse.opts.where(:code => code).first
          __option = MOption.new(:cars_orderno => ordernum, :opt_id => code, :opt_name => _option.desc, :opt_cost => 0)
        end
      end
      puts '=========================================================================================================================================================================='
      puts ordernum
      puts __interior.inspect
      puts __color.inspect
      puts __option.inspect
      puts '----------------------------------------------------------------------------------------------------------------------------------------------------------------------------'
      __option.save if __option
      __color.save
      __interior.save

    
  end
end
