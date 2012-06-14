#encoding: utf-8
class Mssql

  attr_accessor :firstname, :lastname, :dadname, :pass_num, :pass_ser, :pass_whom, :pass_when, :address, :birth



  def save
    self.pass_when= pass_when.strftime('%y / %m / %d')
    query = []
    [:firstname, :lastname, :dadname, :pass_num, :pass_ser, :pass_whom, :pass_when, :address, :birth].each do |i|
      self.send(i)
    end


    client = TinyTds::Client.new(:host => '192.168.1.102', :username => 'aster', :password => '1q2w3e4r5t')
    result = client.execute("INSERT INTO\
      [contragents] ([firstname],[lastname], [dadname],[pass_num],[pass_ser],[pass_whom],[pass_when],[address],[birth])\
      VALUES\
 (#{query})").to_a
    puts result.inspect
  end

  def self.show
    client = TinyTds::Client.new(:host => '192.168.1.102', :username => 'aster', :password => '1q2w3e4r5t')
    result = client.execute('select * from [contragents]').to_a
    puts result.inspect
  end
end