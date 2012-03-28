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
    render :layout => false
  end

  def show
    @person = Person.find(params[:id])
    respond_to do |format|
      format.json { render json: @person }
    end
  end

  def create
    params[:person][:name] = "#{params[:name][:first_name]} #{params[:name][:second_name]} #{params[:name][:third_name]}"
    params[:person][:phones] = params[:person][:phones].values

    @person = Person.new(params[:person])

    respond_to do |format|
      if @person.save
        format.html
      else
        format.js
      end
    end

  end

  def destroy
  end

  def update
    params[:person][:name] = "#{params[:name][:first_name]} #{params[:name][:second_name]} #{params[:name][:third_name]}"
    params[:person][:phones] = params[:person][:phones].values
    @person = Person.find(params[:id])
    if params[:person][:model_id]
      @person.models.find_or_create_by_id(params[:person][:model_id])
    end
    respond_to do |f|
      if @person.update_attributes params[:person]
        f.js {render inline: 'Ok'}
      else
        f.js
      end
    end

  end

end
