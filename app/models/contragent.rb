class Contragent < ActiveRecord::Base
  # attr_accessible :title, :body

 establish_connection(
    :adapter => 'sqlserver',
    # :encoding => 'windows1251',
    :host => '192.168.1.102',
    :username => 'aster',
    :password => '1q2w3e4r5t'

    )
  set_primary_key :id
end
