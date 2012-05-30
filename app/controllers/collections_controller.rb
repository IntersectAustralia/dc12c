class CollectionsController < ApplicationController
  load_and_authorize_resource :collection

  def index
    @collections = Collection.all
  end

  def show
    @collection = Collection.find_by_id! params[:id]
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
