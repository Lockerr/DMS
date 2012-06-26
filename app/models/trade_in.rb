class TradeIn < ActiveRecord::Base
  def attrs(client)

    {
            :fio => client.name
    } if client.valid?

  end
end
