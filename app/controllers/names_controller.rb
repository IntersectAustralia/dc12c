class NamesController < ApplicationController
  load_and_authorize_resource :papyrus
  load_and_authorize_resource :name, through: :papyrus

  def new
  end

  def create
    @name.role = nil if @name.role == ''
    @name.ordering = nil if @name.ordering == ''
    if @name.save
      redirect_to papyrus_path(@papyrus), notice: 'The name was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    params[:name][:role] = nil if params[:name][:role] == ''
    params[:name][:ordering] = nil if params[:name][:ordering] == ''
    if @name.update_attributes(params[:name])
      redirect_to papyrus_path(@papyrus), notice: 'The name was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @name.destroy
    redirect_to papyrus_path(@papyrus), notice: 'The name was deleted.'
  end
end
