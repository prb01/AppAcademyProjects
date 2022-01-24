class CatsController < ApplicationController
  before_action :require_user!, except: [:index, :show]
  before_action :require_owner!, only: [:edit, :update]

  def index
    @cats = Cat.all

    render :index
  end

  def show
    @cat = Cat.find_by(id: params[:id])

    render :show
  end

  def new
    @cat = Cat.new
    @colors = Cat.colors

    render :new
  end

  def create
    @cat = Cat.new(cat_params)
    @cat.user_id = current_user.id

    if @cat.save
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :new
    end
  end

  def edit
    @cat = Cat.find_by(id: params[:id])
    @colors = Cat.colors
    
    render :edit
  end

  def update
    @cat = Cat.find_by(id: params[:id])

    if @cat.update_attributes(cat_params)
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :edit
    end
  end

  private

  def cat_params
    cat_params = params.require(:cat).permit(:name, :birth_date, :sex, :color, :description)
  end

  def require_owner!
    redirect_to cats_url unless current_user.cats.where(id: params[:id]).first
  end
end 