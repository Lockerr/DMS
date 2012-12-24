#encoding: utf-8
class Mssql

  attr_accessor :firstname, :lastname, :dadname, :pass_num, :pass_ser, :pass_whom, :pass_when, :address, :birth
  attr_accessor :ordernum, :price, :prepaid, :dog_num, :dog_date, :client_id, :updated


  #def find(query)
  #  client = TinyTds::Client.new(:host => '192.168.1.102', :username => 'aster', :password => '1q2w3e4r5t')
  #  result = client.execute("select * from [contragents] where #{query}").to_a
  #  result.to_a
  #end

  def exist?
    client = TinyTds::Client.new(:host => '192.168.1.102', :username => 'aster', :password => '1q2w3e4r5t')
    
    result = client.execute("select * from [contragents] where client_id = #{client_id}").to_a
    result.any? ? result.first['id'] : nil

  end


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
    puts query_string

    for key in keys
      if keys.index(key) != 0
        query_keys += ",[#{key}]"
      else
        query_keys += "[#{key}]"
      end
    end
    puts query_keys
    puts "INSERT INTO [contragents]\n (#{query_keys})\n VALUES\n (#{query_string})"

    client = TinyTds::Client.new(:host => '192.168.1.102', :username => 'aster', :password => '1q2w3e4r5t')
    result = client.execute("INSERT INTO [contragents] (#{query_keys}) VALUES (#{query_string})")

    puts result.to_a.inspect
  end

  def update(id)
    query = JSON.parse(to_json).map{|key,value|
      query = ''
      query += key
      query += ' = '
      if value.presence
        query += "'#{value}'"
      else
        query += 'NULL'
      end
      query

    }.join(', ')
    
    client = TinyTds::Client.new(:host => '192.168.1.102', :username => 'aster', :password => '1q2w3e4r5t')
    result = client.execute("update [contragents] SET #{query} where id = #{id}" ).to_a
    result.to_a

  end

  def self.show
    client = TinyTds::Client.new(:host => '192.168.1.102', :username => 'aster', :password => '1q2w3e4r5t')
    result = client.execute('select * from [contragents]').to_a
    result.to_a
  end

  def self.destroy_all_i_am_sure
    client = TinyTds::Client.new(:host => '192.168.1.102', :username => 'aster', :password => '1q2w3e4r5t')
    result = client.execute('delete from [contragents]')
    result.to_a
  end

end