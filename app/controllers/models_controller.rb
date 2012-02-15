class ModelsController < ApplicationController
  def index
    @models = Model.select([:id, :name])
    render :json => @models
  end

  def show
    @models = Models.all

    render :json => @models

  end

  def create

  end

  def update

  end

  def delete

  end

end
