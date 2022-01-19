class CatsController < ApplicationController
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

    if @cat.save
      redirect_to cat_url(@cat)
    else
      redirect_to new_cat_url
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
      redirect_to edit_cat_url(@cat)
    end
  end

  private

  def cat_params
    params.require(:cat).permit(:name, :birth_date, :sex, :color, :description)
  end
end 