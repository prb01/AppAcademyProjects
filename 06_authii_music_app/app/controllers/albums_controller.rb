class AlbumsController < ApplicationController
  before_action :require_user!, except: [:index, :show]
  
  def show
    @album = Album.find_by(id: params[:id])
    render :show
  end

  def new
    @album = Album.new
    @band = Band.find_by(id: params[:band_id])

    render :new
  end

  def create
    @album = Album.new(album_params)

    if @album.save
      redirect_to album_url(@album)
    else
      flash.now[:errors] = @album.errors.full_messages
      render :new
    end
  end

  def edit
    @album = Album.find_by(id: params[:id])
    @band = @album.band

    render :edit
  end

  def update
    @album = Album.find_by(id: params[:id])

    if @album.update_attributes(album_params)
      redirect_to album_url(@album)
    else
      flash.now[:errors] = @album.errors.full_messages
      render :edit
    end
  end

  def destroy
    @album = Album.find_by(id: params[:id])

    if @album.destroy
      redirect_to band_url(@album.artist_id)
    else
      flash.now[:errors] = @album.errors.full_messages
      render :show
    end
  end

  private

  def album_params
    params.require(:album).permit(:title, :year, :studio, :artist_id)
  end
end