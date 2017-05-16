# CatsController
class CatsController < ApplicationController
  before_action :set_cat, only: [:show]

  def index
    cats = Cat.where("address ILIKE '%#{params[:address]}%'")
    @cats = cats.select { |cat| available_for?(cat, params[:date]) }
  end

  def show; end

  def available_for?(cat, date)
    available = true
    if cat.bookings.any?
      cat.bookings.each do |booking|
        available = false if booking.book_date == date
      end
    end
    available
  end

  private

  def set_cat
    @cat = Cat.find(params[:id])
  end
end