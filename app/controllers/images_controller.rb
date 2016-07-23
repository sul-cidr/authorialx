class ImagesController < ApplicationController
  respond_to :json

  def index
    images = Image.all

    if params[:author_id]
      images = Image.where(:author_id => params[:author_id])
    end

    @images = images

  end

  def new
    @image = Image.new
  end

  def create
    @image = Image.new image_params
    @image.save
  end

end
