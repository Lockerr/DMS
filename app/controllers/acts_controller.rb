class ActsController < ApplicationController

  def create
    params[:act][:price].gsub!(/\,/, '.')
    params[:act][:price].gsub!(/\,/, '.')
    @act = Car.find(params[:car_id]).acts.new(params[:act])

    if @act.save
      render :json => @act.id
    end
  end

  def new
    @act = Car.find(params[:car_id]).acts.new

    if @contract = @act.car.contract
      @act.person_id = @contract.person_id
      @act.price = @contract.price
      @act.nds = @contract.price * 18.00 / 118.00
    end

  end

  def show
    @act = Car.find(params[:car_id]).build_act
    @act.person = Person.find(params[:client_id])
    @act.price = params[:price]

    temp = @act.prop
    send_file(temp.to_s + "/act.docx")
    system "rm -r #{temp}"
  end

end
