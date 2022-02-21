class SubsController < ApplicationController
  before_action :require_moderator!, only: [:update]

  def index
    @subs = Sub.all

    render :index
  end

  def show
    @sub = Sub.find_by(id: params[:id])
  end
  
  def new
    render :new
  end

  def create
    @sub = Sub.new(sub_params)

    if @sub.save
      flash[:notify] = ["#{@sub.title} successfully created"]
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :new
    end
  end

  def edit
    @sub = Sub.find_by(id: params[:id])
    render :edit
  end

  def update
    @sub = Sub.find_by(id: params[:id])

    if @sub.update(sub_params)
      flash[:notify] = ["#{@sub.title} successfully updated"]
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :edit
    end
  end

  private

  def sub_params
    params.require(:sub).permit(:title, :description, :moderator_id)
  end
end