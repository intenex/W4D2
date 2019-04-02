class CatsController < ApplicationController
  def index
    @cats = Cat.all
    render 'index'
  end

  def show 
    @cat = Cat.find_by(id: params[:id])
    if @cat
      render 'show'
    else
      redirect_to cats_url
    end
  end

  def new # goes to create
    render 'new'
  end

  def create
    new_cat = Cat.new(cat_params)
    if new_cat.save
      redirect_to cat_url(new_cat)
    else
      render json: new_cat.errors.full_messages
    end
  end

  def edit # goes to update
    @cat = Cat.find_by(id: params[:id])
    if @cat
      render 'edit'
    else
      redirect_to cats_url
    end
  end

  def update
    cat = Cat.find_by(id: params[:id])
    if cat.update(cat_params)
      redirect_to cat_url(cat)
    else
      render json: cat.errors.full_messages
    end
  end

  private
  def cat_params
    params.require(:cat).permit(:name, :sex, :birth_date, :color, :description)
  end
end
