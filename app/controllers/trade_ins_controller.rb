class TradeInsController < ApplicationController
  def new
    @tradein = TradeIn.create
    render :partial => 'form'
  end

  def show
  end

  def create
  end

  def update
  end
end
