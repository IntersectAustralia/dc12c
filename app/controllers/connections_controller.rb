class ConnectionsController < ApplicationController
  load_and_authorize_resource :papyrus
  load_and_authorize_resource :connection, through: :papyrus

  def new
  end

  def create
    update_from_params(@connection)
    if @connection.save
      redirect_to papyrus_path(@papyrus), notice: 'The connection was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    update_from_params(@connection)
    if @connection.save
      redirect_to papyrus_path(@papyrus), notice: 'The connection was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @connection.destroy
    redirect_to papyrus_path(@papyrus), notice: 'The connection was deleted.'
  end


  def update_from_params(connection)
    related_papyrus = Papyrus.find_by_mqt_number(params[:mqt])
    description = params[:description]
    connection.related_papyrus = related_papyrus
    connection.description = description
  end
end
