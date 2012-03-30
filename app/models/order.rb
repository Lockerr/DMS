class Order


  attr_accessor :client, :result, :values

  def connect
    self.client = TinyTds::Client.new(:host => '192.168.1.102', :username => 'aster', :password => '1q2w3e4r5t')
  end

  def select
    result = self.client.execute('select * from [orders]').to_a
  end



end