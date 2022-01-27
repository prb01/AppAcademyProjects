class TracksController < ApplicationController
  before_action :require_user!, except: [:index, :show]
  
  def show
    @track = Track.find_by(id: params[:id])
    @album = @track.album

    render :show
  end

  def new
    @track = Track.new
    @album = Album.find_by(id: params[:album_id])
    @albums = @album.band.albums

    render :new
  end

  def create
    @track = Track.new(track_params)

    if @track.save
      redirect_to track_url(@track)
    else
      flash.now[:errors] = @track.errors.full_messages
      render :new
    end
  end

  def edit
    @track = Track.find_by(id: params[:id])
    @album = @track.album
    @albums = @album.band.albums

    render :edit
  end

  def update
    @track = Track.find_by(id: params[:id])

    if @track.update_attributes(track_params)
      redirect_to track_url(@track)
    else
      flash.now[:errors] = @track.errors.full_messages
      render :edit
    end
  end

  def destroy
    @track = Track.find_by(id: params[:id])

    if @track.destroy
      redirect_to album_url(@track.album_id)
    else
      flash.now[:errors] = @track.errors.full_messages
      render :show
    end
  end

  private

  def track_params
    params.require(:track).permit(:title, :ord, :bonus, :lyrics, :album_id)
  end
end