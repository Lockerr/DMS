#encoding: UTF-8
class ContractsController < ApplicationController

  #TODO: Car can`t be sold again
  #TODO: Can`t show car to client
  #TODO: Can`t send be shown to client
  
  def index
    doc = Document.new
    case params[:doc_type]
      when 1.to_s then
        doc.object = Contract.new
      when 2.to_s then
        doc.object = Act.new
      else
        doc.errors['not_working'] = 'в разработке'
    end
    
    doc.client = Client.find_by_id(params[:client_id])

    response.headers['Access-Control-Allow-Origin'] = '*'

    if doc.generate
      doc = Document.new
      doc.object = Act.new
      doc.generate
      render :json => {:document => 'ok'}
    else
      render :json => {:errors => doc.errors}
    end
  end

  def new
    if params[:car]
      Car.find(params[:car]).contract = Contract.find_or_create_by_car_id(params[:car])
      @contract = Car.find(params[:car]).contract
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
    temp = @contract.prop
    #send_file(temp.to_s + "/contract.docx")

  end

  def create

  end

  def update
    @contract = Contract.find(params[:id])
    params[:contract][:price] = params[:contract][:price].to_s.split(/\D/).join
    params[:contract][:prepay] = params[:contract][:prepay].to_s.split(/\D/).join
    params[:contract][:number] = Time.now.year.to_s[2..3] + '/' + @contract.car.order.to_s[7..10]
    params[:contract][:gifts] = params[:gifts]

    if @contract.update_attributes params[:contract]

      if @person = @contract.person
        if @person.phones.any?
          params[:person][:phones] = @person.phones
        else
          params[:person][:phones] = [params[:person][:phones]]
        end
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