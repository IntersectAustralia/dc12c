class ImagesController < ApplicationController
  load_and_authorize_resource :papyrus
  load_and_authorize_resource :image, through: :papyrus

  def new
  end

  def create
    if @image.save
      redirect_to papyrus_path(@papyrus), notice: 'Your image was successfully uploaded.'
    else
      render :new
    end
  end

  def low_res
    send_file @image.image.path(:low_res)
  end

  def high_res
    send_file @image.image.path(:original)
  end
end
