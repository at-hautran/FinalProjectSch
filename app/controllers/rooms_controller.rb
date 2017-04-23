class RoomsController < ApplicationController
  def index
    @rooms = Room.all.page(params[:page]).per(10)
  end
end
