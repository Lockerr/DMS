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
    @dkp = Car.find(params[:car_id]).build_dkp
    @dkp.person = Person.find(params[:client_id])
    temp = @dkp.prop
    send_file(temp.to_s + "/dkp.docx")
    system "rm -r #{temp}"
  end

end
