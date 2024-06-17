# frozen_string_literal: true

class BooksController < ApplicationController
  def index
    @books = Book.all
  end

  def new
    @book = Book.new
  end

  def show
    @book ||= Book.find(params[:id])
    @author_name ||= @book.author.first_name + " " + (@book.author.last_name || "")
  end
end
