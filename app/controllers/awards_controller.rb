class AwardsController < ApplicationController
  before_filter :fetch_award, except: [:index, :new, :create]
  
  # GET /awards
  # GET /awards.json
  def index
    @awards = Award.all
    @groups = Group.includes(:awards)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @awards }
      format.xlsx
    end
  end

  # GET /awards/1
  # GET /awards/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @award }
    end
  end

  # GET /awards/new
  # GET /awards/new.json
  def new
    @award = Award.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @award }
    end
  end

  # GET /awards/1/edit
  def edit
  end

  # POST /awards
  # POST /awards.json
  def create
    @award = Award.new(params[:award])

    respond_to do |format|
      if @award.save
        format.html { redirect_to @award, notice: 'Award was successfully created.' }
        format.json { render json: @award, status: :created, location: @award }
      else
        format.html { render action: "new" }
        format.json { render json: @award.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /awards/1
  # PUT /awards/1.json
  def update
    respond_to do |format|
      if @award.update_attributes(params[:award])
        format.html { redirect_to @award, notice: 'Award was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @award.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /awards/1
  # DELETE /awards/1.json
  def destroy
    @award.destroy

    respond_to do |format|
      format.html { redirect_to awards_url }
      format.json { head :no_content }
    end
  end
  
  protected
  
  def fetch_award
    @award = Award.where(slug: params[:id]).first
  end
end
