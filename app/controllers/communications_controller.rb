class CommunicationsController < ApplicationController

  def new
    @communication = Person.find(params[:person_id]).communications.new
    render :partial => 'new_communication', :layout => false
  end

  def show

    @communications  = Communication.where(:person_id => params[:id])

    unless @communications
      render :text => "<div class='communication'> empty set </div>"
    end


  end

  def update
    @comminucation = Communication.find(params[:id])

    respond_to do |format|
      if @comminucation.update_attributes(params[:communication])
        format.html { redirect_to Communications_path, notice: 'Communication was successfully created.' }
        format.json { render json: @comminucation, status: :created, location: @comminucation }
      else
        raise @comminucation.errors.inspect
        format.json { render json: @comminucation.errors, status: :unprocessable_entity }
      end
    end

  end

  def create
    @communication = Person.find(params[:person_id]).communications.new(params[:communication])
      respond_to do |format|
        if @communication.save
          format.html
          format.json { render json: @comminucation, status: :created, location: @comminucation }
        else
          raise @communication.errors.inspect
          format.json { render json: @comminucation.errors, status: :unprocessable_entity }
        end
      end
  end

  def destroy
    Communication.find(params[:id]).destroy
    render :text => 'Ok'
  end

end
