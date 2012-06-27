#encoding: utf-8
class Mssql

  attr_accessor :firstname, :lastname, :dadname, :pass_num, :pass_ser, :pass_whom, :pass_when, :address, :birth
  attr_accessor :ordernum, :price, :prepaid, :dog_num,:dog_date


  def save

    values = JSON.parse(self.to_json).values
    keys = JSON.parse(self.to_json).keys

    query_string = ""
    query_keys = ""

    for value in values
      if values.index(value) != 0
        query_string += ",'#{value}'"
      else
        query_string += "'#{value}'"
      end
    end

    query_string = query_string.encode('cp1251')
    Rails.logger.info query_string

    for key in keys
      if keys.index(key) != 0
        query_keys += ",[#{value}]"
      else
        query_keys += "[#{value}]"
      end
    end
    Rails.logger.info "INSERT INTO [contragents]\n (#{query_keys})\n VALUES\n (#{query_string})"

    client = TinyTds::Client.new(:host => '192.168.1.102', :username => 'aster', :password => '1q2w3e4r5t')
    result = client.execute("INSERT INTO [contragents] (#{query_keys}) VALUES (#{query_string})")

    puts result.to_a.inspect
  end

  def self.show
    client = TinyTds::Client.new(:host => '192.168.1.102', :username => 'aster', :password => '1q2w3e4r5t')
    result = client.execute('select * from [contragents]').to_a
    result.to_a
  end
end