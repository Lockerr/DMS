#encoding: utf-8
class UploadController < ApplicationController


  def create
    #debugger
    if params[:car]
      if checkin = Checkin.find(params[:car])
        checkin.assets.push Asset.create(:data => params[:Filedata], :attachable_id => checkin.id, :attachable_type => 'Checkin')
      end
      #Checkin.first.assets.push Asset.create(:data => params[:Filedata])
      render :json => 'true'
    end

  end

  def clear(value)
    if value
      value.gsub!(/(Blue)(EFFICIENCY)/, '')
      value.gsub!(/(Особая серия)/, 'OC')
      value.gsub!(/(Внедорожник)/, '')
      value.gsub!(/(Седан)/, '')
      value.gsub!(/(Особая)/, 'ОС')
      value.gsub!(/(Mercedes\-Benz)/, '')
      value.gsub!(/(\t)/, ' ')
      value.gsub!(/(\s)/, ' ')
      value.gsub!(/(\ \ )/, ' ')
      value.gsub!(/(\s\s)/, ' ')
      value.gsub!(/(^\s)/, '')
      value.gsub!(/(\w)(\d\d\d)/, '\1 \2')
      value.gsub!(/(Coupe)/, 'Купе')
      value
    end


  end

  def state
    if request.post?
      data = params[:Filedata].tempfile
      book = Hpricot.parse data
      counter = book.search('//tr').count
      (1..counter).each do |i|
        row = []
        if book.search('//tr')[i]
          row[2]  = book.search('//tr')[i].search('//td')[2].inner_text
          row[3]  = book.search('//tr')[i].search('//td')[3].inner_text
          row[9]  = book.search('//tr')[i].search('//td')[9].inner_text
          row[30] = book.search('//tr')[i].search('//td')[30].inner_text
          row[31] = book.search('//tr')[i].search('//td')[31].inner_text
          row[32] = book.search('//tr')[i].search('//td')[32].inner_text
          row[39] = book.search('//tr')[i].search('//td')[39].inner_text
          row[41] = book.search('//tr')[i].search('//td')[41].inner_text
          row[34] = book.search('//tr')[i].search('//td')[34].inner_text
          row[33] = book.search('//tr')[i].search('//td')[33].inner_text

          opts = []
          row[34] ? opts += row[33].split('.') + row[34].split('.') : opts += row[33].split('.') if row[34]

          attributes =
              {
                  :order         => row[2],
                  :vin           => row[3],
                  :model         => Model.find_or_create_by_name(clear(row[30])),
                  :klasse_id     => Klasse.find_by_name(clear((row[30]).split(/\s/)[0])).id,
                  :color_id      => row[31],
                  :interior_id   => row[32],
                  :arrival       => row[39],
                  :engine_number => row[41],
                  :real_options  => opts,
                  :prod_date => row[9]
              }

          if car = Car.find_by_order(row[2].to_s)
            car.update_attributes(attributes)
          else
            Car.create(attributes)
          end
        end

      end
    end
  end


end




