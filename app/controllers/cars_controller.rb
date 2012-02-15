class CarsController < ApplicationController

  def index
    @cars = Car.scoped

    if params[:search]
      search = params[:search].delete_if { |key, value| value.empty? }
      c      = Car.arel_table
      #raise c['model_id']

      for key in search.keys
        case key
          when 'model'
            if models = Model.where("name LIKE ?", "%" + search[key] + "%")
              @cars = @cars.where(c['model_id'].in models.map(&:id))
            else
              @cars = nil
            end
          when 'manager'
            if models = Manager.where("name LIKE ?", "%" + search[key] + "%")
              @cars = @cars.where(c['manager_id'].in models.map(&:id))
            else
              @cars = nil
            end
          when 'klasse'
            if models = Klasse.where("name LIKE ?", "%" + search[key] + "%")
              @cars = @cars.where(c['klasse_id'].in models.map(&:id))
            else
              @cars = nil
            end
          when 'line'
            if models = Line.where("name LIKE ?", "%" + search[key] + "%")
              @cars = @cars.where(c['line_id'].in models.map(&:id))
            else
              @cars = nil
            end
          when 'id', 'price'
            @cars = @cars.where(c[key].eq search[key])

          when 'unpublished'
            @cars = @cars.where(:published => false) if search[key] == "1"

          when 'published'
            @cars = @cars.where(:published => true) if search[key] == "1"


          else
            @cars = @cars.where(c[key].matches "%#{search[key]}%")
        end
      end
    end



    respond_to do |format|
      format.html
      format.xml { render :json => Car.all }
      format.js { render :partial => 'cars', :collections => @cars }
      format.json { render :partial => 'car', :collections => @cars = Car.all }
    end
  end

  def new
    @car = Car.new
  end

  def show
    @car = Car.find(params[:id])
    respond_to do |f|
        f.html {render :layout => false}
        f.pdf {render :layout => 'pdf'}
      end
  end

  def info
    @car = Car.find(params[:id])
    @objects = []
    @objects += @car.proposals
    @objects.compact!
    @objects.sort! {|x,y| x.updated_at <=> y.updated_at }
    @objects.push @car.manager if @car.manager
    @objects.push @car.contract if @car.contract
    for checkin in @car.checkins
      @objects.push checkin
    end
    @objects.compact!

    render :layout => false
  end

  def update

    @car = Car.find(params[:id])

    respond_to do |format|
      if @car.update_attributes(params[:car])
        format.html { render :layout => false}
      else
        raise @car.errors.inspect
        format.json { render json: @car.errors, status: :unprocessable_entity }
      end
    end

  end

  def edit
    @car = Car.find(params[:id])
    render :layout => false
  end

  def create

    @car = Car.new(params[:car])


    if params[:new][:model_name] != ''
      @car.model_id = Model.find_or_create_by_name(params[:new][:model_name]).id
    end

    if params[:new][:line_name]
      @car.line_id = Line.find_or_create_by_name(params[:new][:line_name]).id
    end

    if params[:new][:person_name]
      @car.line_id = Person.find_or_create_by_name(params[:new][:person_name]).id
    end


    respond_to do |format|
      if @car.save
        format.html { redirect_to cars_path, notice: 'Car was successfully created.' }
        format.json { render json: @car, status: :created, location: @car }
      else
        #raise @car.errors.inspect
        format.json { render json: @car.errors, status: :unprocessable_entity, errors: @car.errors.messages }
      end
    end

  end

  def destroy
    Car.find(params[:id]).destroy
    render :text => 'Ok'
  end


end


