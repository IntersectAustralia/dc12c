class CollectionsController < ApplicationController
  load_and_authorize_resource :collection

  set_tab :collections

  def index
  end

  def show
    respond_to do |format|
      format.html
      format.xml { render xml: @collection.to_rifcs }
    end
  end

  def new
  end

  def create
    if @collection.save
      redirect_to collection_path(@collection), notice: 'The collection was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @collection.update_attributes(params[:collection])
      redirect_to collection_path(@collection), notice: 'The collection was successfully updated.'
    else
      render :edit
    end
  end
end
