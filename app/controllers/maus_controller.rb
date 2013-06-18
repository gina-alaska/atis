class MausController < ApplicationController
  # GET /maus
  # GET /maus.json
  def index
    @maus = Mau.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @maus }
    end
  end

  # GET /maus/1
  # GET /maus/1.json
  def show
    @mau = Mau.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @mau }
    end
  end

  # GET /maus/new
  # GET /maus/new.json
  def new
    @mau = Mau.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @mau }
    end
  end

  # GET /maus/1/edit
  def edit
    @mau = Mau.find(params[:id])
  end

  # POST /maus
  # POST /maus.json
  def create
    @mau = Mau.new(params[:mau])

    respond_to do |format|
      if @mau.save
        format.html { redirect_to maus_path, notice: 'Mau was successfully created.' }
        format.json { render json: @mau, status: :created, location: @mau }
      else
        format.html { render action: "new" }
        format.json { render json: @mau.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /maus/1
  # PUT /maus/1.json
  def update
    @mau = Mau.find(params[:id])

    respond_to do |format|
      if @mau.update_attributes(params[:mau])
        format.html { redirect_to maus_path, notice: 'Mau was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @mau.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /maus/1
  # DELETE /maus/1.json
  def destroy
    @mau = Mau.find(params[:id])
    @mau.destroy

    respond_to do |format|
      format.html { redirect_to maus_url }
      format.json { head :no_content }
    end
  end
end
