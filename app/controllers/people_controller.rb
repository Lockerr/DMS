class PeopleController < ApplicationController

  def index
    @people = Person.scoped

    if params[:search]
      search = params[:search].delete_if { |key, value| value.empty? }

      c = Person.arel_table

      for key in search.keys
        @people = @people.where(c[key].matches "%#{search[key]}%")
      end
    end

    respond_to do |format|
      format.js { render :partial => 'people', :collections => @people }
      format.html
    end

  end


  def new
    @person = Person.new
    render :partial => 'new_person', :layout => false
  end

  def edit
    @person = Person.find(params[:id])
  end

  def show
    @person = Person.find(params[:id])
    respond_to do |format|
      format.json { render json: @person }
    end
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
