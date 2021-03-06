class CatsController < ApplicationController
  before_action :set_cat, only: %i(show destroy edit update)

  def index
    session[:date] = params[:cat][:date]
    request_date = Date.parse(session[:date])
    @cats = Cat.near(params[:cat][:address], 20)
               .select { |cat| available_for?(cat, request_date) }
  end

  def show; end

  def mycats
    @cats = current_user.cats
  end

  def new
    @cat = current_user.cats.new
  end

  def create
    @cat = current_user.cats.new(cat_params)
    if @cat.save
      redirect_to @cat
    else
      render :new
    end
  end

  def edit

  end

  def update
    if @cat.update(cat_params)
      redirect_to @cat
    else
      render :edit
    end
  end

  def available_for?(cat, date)
    available = true
    if cat.bookings.any?
      cat.bookings.each do |booking|
        if booking.book_date == date
          available = false
          break
        end
      end
    end
    available
  end

  def destroy
    @cat.destroy
    redirect_to mycats_cats_path
  end

  private

  def set_cat
    @cat = Cat.find(params[:id])
  end

  def cat_params
    params.require(:cat).permit(:name, :description, :photo, :address, :price)
  end
end
