class PapyriController < ApplicationController
  load_and_authorize_resource
  # GET /papyri
  # GET /papyri.json
  def index
    page = make_page(params[:page])
    @papyri = @papyri.paginate(page: page, per_page: APP_CONFIG['number_of_papyri_per_page'])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @papyri }
    end
  end

  # GET /papyri/1
  # GET /papyri/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @papyrus }
    end
  end

  # GET /papyri/new
  # GET /papyri/new.json
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @papyrus }
    end
  end

  # GET /papyri/1/edit
  def edit
  end

  # POST /papyri
  # POST /papyri.json
  def create
    @papyrus.date_era = nil if @papyrus.date_era.blank?
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
    respond_to do |format|
      params[:papyrus][:language_ids] ||= []
      if @papyrus.update_attributes(params[:papyrus])
        format.html { redirect_to @papyrus, notice: 'Papyrus was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @papyrus.errors, status: :unprocessable_entity }
      end
    end
  end

  def search
    page = make_page(params[:page])
    search_query = params[:search]
    search_terms = search_query.split /\s+/
    search_results = Papyrus.search(search_terms)
    @papyri = search_results.accessible_by(current_ability).paginate(page: page, per_page: APP_CONFIG['number_of_papyri_per_page'])
  end

  private

  def make_page(page)
    page.to_i < 1 ? 1 : page
  end

end
