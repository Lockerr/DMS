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

  def write_options
  
  end

end
