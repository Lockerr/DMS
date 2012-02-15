class PeopleController < ApplicationController

  def index
    @people = Person.scoped
  end

  def new
    @person = Person.new
    render :partial => 'new_person', :layout => false
  end

  def show

  end

  def create



      @person = Person.new(params[:person])

      respond_to do |format|
        if @person.save
          format.html
        else
          raise @person.errors.inspect
          format.json { render json: @person.errors, status: :unprocessable_entity }
        end
      end

  end

  def destroy
  end

  def update
    @person = Person.find(params[:id])

    if @person.update_attributes params[:person]
      render json: @person
    end
  end

end
