# frozen_string_literal: true

class RoomsController < ApplicationController
  def index
    @rooms = Room.all
  end

  def new
    @room = Room.new
  end

  def show
    @room ||= Room.find(params[:id])
    @books ||= @room.books
  end
end