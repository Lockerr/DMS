class DkpsController < ApplicationController

  def create
    params[:dkp][:price].gsub!(/\,/, '.')
    params[:dkp][:price].gsub!(/\,/, '.')
    @dkp = Car.find(params[:car_id]).dkps.new(params[:dkp])

    if @dkp.save
      render :json => @dkp.id
    end
  end

  def new
    @dkp = Dkp.find_or_create_by_car_id(params[:car_id])
  end

  def show
    @dkp = Dkp.find(params[:id])
    temp = @dkp.prop
    send_file(temp.to_s + "/dkp.docx")
    system "rm -r #{temp}"
  end

end
