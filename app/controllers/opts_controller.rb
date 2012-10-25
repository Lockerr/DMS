class OptsController < ApplicationController
  # GET /opts
  # GET /opts.json
  layout 'manage'
  def index
    @opts = Opt.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @opts }
    end
  end

  # GET /opts/1
  # GET /opts/1.json
  def show
    @opt = Opt.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @opt }
    end
  end

  # GET /opts/new
  # GET /opts/new.json
  def new
    @opt = Opt.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @opt }
    end
  end

  # GET /opts/1/edit
  def edit
    @opt = Opt.find(params[:id])
  end

  # POST /opts
  # POST /opts.json
  def create
    @opt = Opt.new(params[:opt])

    respond_to do |format|
      if @opt.save
        format.html { redirect_to @opt, notice: 'Opt was successfully created.' }
        format.json { render json: @opt, status: :created, location: @opt }
      else
        format.html { render action: "new" }
        format.json { render json: @opt.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /opts/1
  # PUT /opts/1.json
  def update
    @opt = Opt.find(params[:id])

    respond_to do |format|
      if @opt.update_attributes(params[:opt])
        format.html { redirect_to @opt, notice: 'Opt was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @opt.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /opts/1
  # DELETE /opts/1.json
  def destroy
    @opt = Opt.find(params[:id])
    @opt.destroy

    respond_to do |format|
      format.html { redirect_to opts_url }
      format.json { head :no_content }
    end
  end
end
