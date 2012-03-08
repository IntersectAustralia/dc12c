class PapyriController < ApplicationController
  # GET /papyri
  # GET /papyri.json
  def index
    @papyri = Papyrus.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @papyri }
    end
  end

  # GET /papyri/1
  # GET /papyri/1.json
  def show
    @papyrus = Papyrus.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @papyrus }
    end
  end

  # GET /papyri/new
  # GET /papyri/new.json
  def new
    @papyrus = Papyrus.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @papyrus }
    end
  end

  # GET /papyri/1/edit
  def edit
    @papyrus = Papyrus.find(params[:id])
  end

  # POST /papyri
  # POST /papyri.json
  def create
    @papyrus = Papyrus.new(params[:papyrus])

    respond_to do |format|
      if @papyrus.save
        format.html { redirect_to @papyrus, notice: 'Your Papyrus record has been created.' }
        format.json { render json: @papyrus, status: :created, location: @papyrus }
      else
        format.html { render action: "new" }
        format.json { render json: @papyrus.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /papyri/1
  # PUT /papyri/1.json
  def update
    @papyrus = Papyrus.find(params[:id])

    respond_to do |format|
      if @papyrus.update_attributes(params[:papyrus])
        format.html { redirect_to @papyrus, notice: 'Papyrus was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @papyrus.errors, status: :unprocessable_entity }
      end
    end
  end

end
