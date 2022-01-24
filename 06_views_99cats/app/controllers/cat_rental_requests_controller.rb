class CatRentalRequestsController < ApplicationController
  before_action :require_owner!, only: [:approve, :deny]

  def new
    @cr = CatRentalRequest.new
    @cats = Cat.all.select(:name, :id)

    render :new
  end

  def create
    @cr = CatRentalRequest.new(cr_params)
    
    if @cr.save
      redirect_to cat_url(@cr.cat)
    else
      flash[:errors] = @cr.errors.full_messages
      redirect_to new_cat_rental_request_url
    end
  end

  def approve
    @cr = CatRentalRequest.find_by(id: params[:id])

    @cr.approve!
    redirect_to cat_url(@cr.cat)
  end

  def deny
    @cr = CatRentalRequest.find_by(id: params[:id])

    @cr.deny!
    redirect_to cat_url(@cr.cat)
  end

  private

  def cr_params
    params.require(:rental_request).permit(:cat_id, :start_date, :end_date)
  end

  def require_owner!
    redirect_to cats_url unless current_user.cat_rental_requests.where(id: params[:id]).first
  end
end