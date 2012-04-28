# encoding: utf-8
class ProposalsController < ApplicationController

  def new
    @car = Car.find(params[:car_id])
    if @car.can_be_proposed?
      @proposal = @car.proposals.new
    else
      render :inline => "Машина не может быть предложена. #{t(@car.state)}"
    end
  end

  def show
    @proposal = Car.find(params[:car_id]).build_proposal
    @proposal.person = Person.find(params[:client_id])
    @proposal.manager = Manager.find(params[:manager_id])
    temp = @proposal.prop
    send_file(temp.to_s + "/proposal.docx")
    #system "rm -r #{temp}"
  end

  def create
    params[:proposal][:price].gsub!(/\,/, '.')
    params[:proposal][:special_price].gsub!(/\,/, '.')
    @proposal = Car.find(params[:car_id]).proposals.new(params[:proposal])

    if @proposal.save
      render :json => @proposal.id
    end
  end


  def update

  end


end
