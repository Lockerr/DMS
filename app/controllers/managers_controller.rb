class ManagersController < ApplicationController
  def index
    @managers = Manager.select([:id, :name])
    render :json => @managers

  end

  def show
  end

  def create
  end

  def update
  end

  def delete
  end

end
