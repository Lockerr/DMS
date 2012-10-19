class MCar < ActiveRecord::Base
  
  
  establish_connection(
    :adapter => 'mysql2',
    :encoding => 'utf8',
    :database => 'mbclub74',
    :host => 'mbclub74.ru',
    :username => 'lynx',
    :password => 'lyna123'

    )
  set_table_name 'mbclub74.cars'
  
  bad_attribute_names :class

  def write_options
  
  end

def class_name= value
  self[:class] = value
end

def class_name
  self[:class]
end


end
