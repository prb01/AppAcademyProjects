class NotesController < ApplicationController
  before_action :require_user!
  before_action :require_note_owner!, only: [:destroy]

  def create
    @note = Note.new(note_params)
    @track = Track.find_by(id: params[:track_id])
    
    @note.track_id = @track.id
    @note.user_id = current_user.id

    if @note.save
      redirect_to track_url(@track)
    else
      flash[:errors] = @note.errors.full_messages
      redirect_to track_url(@track)
    end
  end

  def destroy
    @note = Note.find_by(id: params[:id])
    @track = @note.track

    if @note.destroy
      redirect_to track_url(@track)
    else
      flash[:errors] = @note.errors.full_messages
      redirect_to track_url(@track)
    end
  end

  private

  def note_params
    params.require(:note).permit(:body)
  end

  def require_note_owner!
    @note = Note.find_by(id: params[:id])
    @track = @note.track

    if current_user.id != @note.user.id
      redirect_to track_url(@track)
    else
      return true
    end
  end
end