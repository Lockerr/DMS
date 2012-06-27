class Order < ActiveRecord::Base

  belongs_to :person
  belongs_to :car


  def self.store
    client = TinyTds::Client.new(:host => '192.168.1.102', :username => 'aster', :password => '1q2w3e4r5t')
    result = client.execute('select * from [orders]').to_a
    for r in result

      {
              'id' => 14.0,
              "order_num" => "\xD3\xC055888/\xD2",
              "client_name" => "\xD8\xE8\xF0\xEE\xEA\xEE\xE2 \xC8\xEB\xFC\xFF \xDE\xF0\xFC\xE5\xE2\xE8\xF7",
              "client_phone" => "919-339-9074",
              "client_crm_id" => "00001607  ",
              "car_name" => "MERCEDES-BENZ SL 55 AMG",
              "car_year" => 2003,
              "car_run" => "11",
              "problem" => "\xE0\xE2\xF2\xEE\xEC\xEE\xE1\xE8\xEB\xFC \xEF\xE0\xE4\xE0\xE5\xF2 \xED\xE0 \xEB\xE5\xE2\xF3\xFE \xF1\xF2\xEE\xF0\xEE\xED\xF3\r\n\xED\xE5 \xEE\xF2\xEA\xF0\xFB\xE2\xE0\xE5\xF2\xF1\xFF \xE2\xE5\xF9\xE5\xE2\xEE\xE9 \xFF\xF9\xE8\xEA",
              "solution" => " ",
              "master" => "\xD1\xF2\xE5\xE6\xEA\xE8\xED \xC0 \xC2",
              "dispatcher" => "\xC0\xED\xFF \xC5\xEB\xF1\xF3\xEA\xEE\xE2\xE0",
              "order_sum" => "20547.040000",
              "order_open" => "04.08.11",
              "order_close" => "04.08.11",
              "car_gone" => "02.03.12",
              "call_result" => 0,
              "call_description" => " ",
              "VIN" => nil
      }

      for key in r.keys
        r[key] = r[key].force_encoding('cp1251').encode('UTF-8') if r[key].class == String
      end

      unless order = Order.find_by_source_id(r['id'].to_i)

        order = Order.new
        order.source_id = r['id'].to_i
        order.number = r['order_num']
        order.problem = r['problem']
        order.solution = r['solution']
        order.number = r['order_num']
        order.problem = r['problem']
        order.solution = r['solution']
        order.dispatcher = r['dispatcher']
        order.sum = r['order_sum']
        order.opened = Time.parse r['order_open'] if r['order_open'].scan(/\d/).size == 8
        order.closed = Time.parse r['order_close'] if r['order_close'].scan(/\d/).size == 8
        order.gone = Time.parse r['car_gone'] if  r['order_close'].scan(/\d/).size == 8
        order.vin = r['VIN']
        order.call_result = r['call_result']
        order.description = r['description']
        order.master = r['master']
        order.modelname = r['car_name']
        if order.save

          car = Car.new
          car.used_vin = order.vin
          car.modelname = order.modelname

          #client = Client.where(:phone => order.phone).first
          #if client
          #  client.used_car = car
          #else
          #  client = Client.new
          #  client.phone1 = Order.phone
          #  client.fio = order
          #
          #
          #end


        end

      else

        order.source_id = r['id'].to_i
        order.number = r['order_num']
        order.problem = r['problem']
        order.solution = r['solution']
        order.number = r['order_num']
        order.problem = r['problem']
        order.solution = r['solution']
        order.dispatcher = r['dispatcher']
        order.sum = r['order_sum']
        order.opened = Time.parse r['order_open'] if r['order_open'].scan(/\d/).size == 8
        order.closed = Time.parse r['order_close'] if r['order_close'].scan(/\d/).size == 8
        order.gone = Time.parse r['car_gone'] if  r['order_close'].scan(/\d/).size == 8
        order.vin = r['VIN']
        order.call_result = r['call_result']
        order.description = r['description']
        order.master = r['master']
        order.modelname = r['car_name']
        order.save

      end


    end


  end


end