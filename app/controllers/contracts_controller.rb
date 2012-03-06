#encoding: UTF-8
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
      if @person = Person.find_by_id(params[:person])
        @contract = @person.contracts.create
      end
      render :partial => 'person_form'
    end

  end

  def show
    @contract = Contract.find(params[:id])
    temp = @contract.prop
    send_file(temp.to_s + "/contract.docx")
    system "rm -r #{temp}"
  end

  def create

  end

  def update
    @contract = Contract.find(params[:id])
    params[:contract][:price] = params[:contract][:price].to_s.split(/\D/).join
    params[:contract][:prepay] = params[:contract][:prepay].to_s.split(/\D/).join

    params[:contract][:gifts] = params[:gifts]

    if @contract.update_attributes params[:contract]

      if @person = @contract.person
        @person.update_attributes params[:person]
      else

        if @person = Person.new(params[:person])
          if @person.save
            @contract.person = @person
            if @contract.save
              temp = @contract.prop
              send_file(temp.to_s + "/contract.docx")
              system "rm -r #{temp}"
            else
              render :json => 'ошибка сохранениея контракта', :status => :unprocessable_entity
            end
          else
            render :json => 'Клиент с такими паспортными данными уже существует', :status => :unprocessable_entity
          end
        end
      end


    end
    render :json => 'true'
  end


end

