#encoding: utf-8
class Model < ActiveRecord::Base
  has_many :cars
  has_and_belongs_to_many :people, :uniq => true

  def substitute_name
    update_attributes :name => name.gsub(/"Особая с/,'')
                          .gsub(/Особая/,'')
                          .gsub(/BlueEFFICIENCY/,'')
                          .gsub(/BlueEFFICIENCY/,'')
                          .gsub(/Седан/,'')
                          .gsub(/MERCEDES-BENZ/, '')
                          .gsub(/Внедорожник/, '')
                          .gsub(/4MATIC/, '')
                          .gsub(/  /,' ')
                          .gsub(/ $/,'')
                          .gsub(/^ /,'')
                          .gsub(/  /,' ')
                          .gsub('ОС','')
                          .gsub('OC','')
                          .gsub('Серия','')
                          .gsub(/\s+$/,'')
  end
end
