class CatRentalRequestsController < ApplicationController
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
      redirect_to new_cat_url
    end
  end

  private

  def cr_params
    params.require(:rental_request).permit(:cat_id, :start_date, :end_date)
  end
end