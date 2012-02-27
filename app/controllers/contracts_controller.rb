class ContractsController < ApplicationController

  #TODO: Car can`t be sold again
  #TODO: Can`t show car to client
  #TODO: Can`t send be shown to client

  def index

  end

  def new
    if params[:car]
      @contract = Car.find(params[:car]).contract = Contract.create(:car_id => params[:car])
      render :partial => 'car_form'
    end

    if params[:person]
      @contract = Person.find(params[:person]).contracts.create
      render :partial => 'person_form'
    end

  end

  def show
    @contract = Contract.find(params[:id])
    PDFKit.configure do |config|
      config.default_options = {
          :page_size     => 'A4',
          :margin_top    => '5mm',
          :margin_right  => '5mm',
          :margin_bottom => '5mm',
          :margin_left   => '15mm',

      }
    end
    respond_to do |format|
      format.pdf { render :layout => 'pdf' }
      format.html { render :layout => 'pdf'}
    end
  end

  def create

  end

  def update
    @contract                  = Contract.find(params[:id])
    params[:contract][:price]  = params[:contract][:price].to_s.to_s.split(/\D/).join
    params[:contract][:prepay] = params[:contract][:prepay].to_s.to_s.split(/\D/).join
    @person = @contract.person
    @person.update_attributes params[:person]

    if @contract.update_attributes params[:contract]

    end
  end

  def pdf
    respond_to do |format|
      format.pdf { render :layout => 'pdf' }
    end
  end

end
