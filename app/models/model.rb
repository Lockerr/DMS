#encoding: utf-8
class Model < ActiveRecord::Base
  has_many :cars
  # has_and_belongs_to_many :people
  belongs_to :klasse

  validates_presence_of :name


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

  def get_or_create_model_from_string(string)
    inner_text.scan(/([\w]{1,3}?)\s?(\d{2,3})|(VIANO)\s(\w+)/)[0].delete_if(&:nil?)[1]
  end

end
