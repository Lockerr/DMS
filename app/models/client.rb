#encoding: utf-8
class Client < ActiveRecord::Base
  alias_attribute :contract_date, :date_contract
  alias_attribute :birthday, :clientbirthday
  alias_attribute :id_series, :pas1
  alias_attribute :id_number, :pas2
  alias_attribute :id_dep, :pas3

  with_options :if => "cause == 1" do |client|
    client.validates :prepay, :cost, :birthday, :phone1, :contract_date, :vin ,:adress, :presence => 'true'
    client.validates_presence_of :id_series, :id_number, :id_dep
    client.validates_format_of :id_series, :id_number, :with => /[\d\s]/
    client.validates_presence_of :fio
    client.validates :car, :presence => true
  end

  with_options :if => 'cause == 5' do |client|
    client.validates_presence_of :fio, :manager, :trade_in_price, :trade_in_desc
    client.validates_associated :used_car

  end

  set_table_name '1_clients'

  has_one :used_car, :class_name => Car, :foreign_key => :used_vin, :primary_key => :used_vin
  has_one :car, :foreign_key => :order, :primary_key => :vin

  def price_kop
    if cost.to_s.split('.').size == 2
      kopejki = price.to_s.split('.')[1]
      propis = RuPropisju.kopeek(kopejki.to_i)
      if kopejki.to_i < 10
        propis = '0' + propis
      end

    else
      propis = '00 копеек'
    end
    if propis.to_i == 0
      propis = '00 копеек'
    end
    propis
  end

  def prepay_kop
    if cost.to_s.split('.').size == 2
      kopejki = prepay.to_s.split('.')[1]
      propis = RuPropisju.kopeek(kopejki.to_i)
      if kopejki.to_i < 10
        propis = '0' + propis
      end

    else
      propis = '00 копеек'
    end
    if propis.to_i == 0
      propis = '00 копеек'
    end
    propis
  end

  def short_name
    n = fio.split(/(\s|\.)/).delete_if { |i| i == '.' || i == ' ' }

    if n.count == 3
      "#{n[0]} #{n[1][0]}. #{n[2][0]}."
    else
      self.fio
    end
  end

end
