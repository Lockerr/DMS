class ContractsController < ApplicationController

  #TODO: Car can`t be sold again
  #TODO: Can`t show car to client
  #TODO: Can`t send be shown to client

  def index

  end

  def new
    @contract = Car.find(params[:car]).contract = Contract.create
    render :partial => 'form'

  end

  def show
    @contract = Contract.find(params[:id])
    respond_to do |format|
      format.pdf {render :layout => 'pdf'}
      format.html
    end
  end

  def create

  end

  def update
    @contract = Contract.find(params[:id])
    params[:contract][:price] = params[:contract][:price].to_s.to_s.split(/\D/).join
    params[:contract][:prepay] = params[:contract][:prepay].to_s.to_s.split(/\D/).join

    if @contract.update_attributes params[:contract]

    end
  end

  def pdf
    respond_to do |format|
      format.pdf {render :layout => 'pdf'}
    end
  end

end
