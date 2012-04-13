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
    date_errors = set_dates(@papyrus, params)
    respond_to do |format|
      if @papyrus.save and date_errors.empty?
        format.html { redirect_to @papyrus, notice: 'Your Papyrus record has been created.' }
        format.json { render json: @papyrus, status: :created, location: @papyrus }
      else
        append_date_errors(@papyrus, date_errors)
        format.html { render action: "new" }
        format.json { render json: @papyrus.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /papyri/1
  # PUT /papyri/1.json
  def update
    errors = set_dates(@papyrus, params)
    respond_to do |format|
      params[:papyrus][:language_ids] ||= []
      if @papyrus.update_attributes(params[:papyrus]) and errors.empty?
        format.html { redirect_to @papyrus, notice: 'Papyrus was successfully updated.' }
        format.json { head :no_content }
      else
        append_date_errors(@papyrus, errors)
        format.html { render action: "edit" }
        format.json { render json: @papyrus.errors, status: :unprocessable_entity }
      end
    end
  end

  def search
    page = make_page(params[:page])
    search_query = params[:search]
    search_terms = search_query.split /\s+/
    if search_terms.empty?
      @simple_search_error = 'Please enter a search query.'
      render 'pages/home'
    else
      search_results = Papyrus.search(search_terms)
      @papyri = search_results.accessible_by(current_ability).paginate(page: page, per_page: APP_CONFIG['number_of_papyri_per_page'])
    end
  end

  def advanced_search
    page = make_page(params[:page])
    @with_params = params.include?(:utf8)
    fields = ['inventory_id', 'general_note', 'lines_of_text', 'paleographic_description', 'recto_note', 'verso_note', 'origin_details', 'source_of_acquisition', 'preservation_note', 'language_note', 'summary', 'original_text', 'translated_text']
    search_fields = params.keep_if do |name, value|
      value.present? && fields.include?(name.to_s)
    end
    if !search_fields.empty?
      @search_fields = search_fields
      @papyri = Papyrus.advanced_search(search_fields).accessible_by(current_ability, :advanced_search).paginate(page: page, per_page: APP_CONFIG['number_of_papyri_per_page'])
    else
      @search_fields = {}
      @papyri = []
    end
  end

  def request_access
    AccessRequest.place_request(current_user, @papyrus)
    redirect_to @papyrus, notice: 'Your request has been received.'
  end

  def cancel_access_request
    AccessRequest.find_by_user_id_and_papyrus_id!(current_user, @papyrus).destroy
    redirect_to @papyrus, notice: 'Your request has been cancelled.'
  end

  private

  def make_page(page)
    page.to_i < 1 ? 1 : page
  end

  def set_dates(papyrus, params)
    errors = []
    if ['BCE', 'CE'].include? params[:papyrus_date_from_era]
      multiplier = 'CE' == params[:papyrus_date_from_era] ? 1 : -1
      papyrus.date_from = params[:papyrus_date_from_year].to_i * multiplier
    elsif params[:papyrus_date_from_year].present?
      errors << 'Fill in Date From Era'
    else
      papyrus.date_from = nil
    end
    if ['BCE', 'CE'].include? params[:papyrus_date_to_era]
      multiplier = 'CE' == params[:papyrus_date_to_era] ? 1 : -1
      papyrus.date_to = params[:papyrus_date_to_year].to_i * multiplier
    elsif params[:papyrus_date_to_year].present?
      errors << 'Fill in Date To Era'
    else
      papyrus.date_to = nil
    end
    errors
  end

  def append_date_errors(papyrus, errors)
    errors.each do |error|
      papyrus.errors[:base] << error
    end
  end

end
