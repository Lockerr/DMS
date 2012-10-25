class InteriorsController < ApplicationController
  # GET /interiors
  # GET /interiors.json
  layout 'manage'
  
  def index
    @interiors = Interior.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @interiors }
    end
  end

  # GET /interiors/1
  # GET /interiors/1.json
  def show
    @interior = Interior.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @interior }
    end
  end

  # GET /interiors/new
  # GET /interiors/new.json
  def new
    @interior = Interior.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @interior }
    end
  end

  # GET /interiors/1/edit
  def edit
    @interior = Interior.find(params[:id])
  end

  # POST /interiors
  # POST /interiors.json
  def create
    @interior = Interior.new(params[:interior])

    respond_to do |format|
      if @interior.save
        format.html { redirect_to @interior, notice: 'Interior was successfully created.' }
        format.json { render json: @interior, status: :created, location: @interior }
      else
        format.html { render action: "new" }
        format.json { render json: @interior.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /interiors/1
  # PUT /interiors/1.json
  def update
    @interior = Interior.find(params[:id])

    respond_to do |format|
      if @interior.update_attributes(params[:interior])
        format.html { redirect_to @interior, notice: 'Interior was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @interior.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /interiors/1
  # DELETE /interiors/1.json
  def destroy
    @interior = Interior.find(params[:id])
    @interior.destroy

    respond_to do |format|
      format.html { redirect_to interiors_url }
      format.json { head :no_content }
    end
  end
end
