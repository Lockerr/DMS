#encoding: utf-8
class CheckinsController < ApplicationController
  def new
    @checkin = Car.find(params[:car]).checkins.create
    render :partial => 'form'
  end

  def update
    @car = Checkin.find(params[:id])

    if @car.update_attributes params[:checkin]
      render :text => params.inspect
    else
      render :text => @car.errors.inspect
    end

  end

end
