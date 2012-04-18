class ImagesController < ApplicationController
  load_and_authorize_resource :papyrus
  load_and_authorize_resource :image, through: :papyrus

  def new
  end

  def create
    @image.ordering = nil if @image.ordering == ''
    if @image.save
      redirect_to papyrus_path(@papyrus), notice: 'Your image was successfully uploaded.'
    else
      render :new
    end
  end

  def thumbnail
    send_file @image.image.path(:thumbnail)
  end

  def low_res
    send_file @image.image.path(:low_res), filename: @image.low_res_filename
  end

  def high_res
    send_file @image.image.path(:original), filename: @image.high_res_filename
  end
end
