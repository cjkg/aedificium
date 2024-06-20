# frozen_string_literal: true
# lib/clients/open_library_books_api.rb

class OpenLibraryBooksApi
  include HTTParty
  base_uri 'https://openlibrary.org'

  def initialize
  end

  def isbn(isbn)
    self.class.get("/isbn/#{isbn_cleaner(isbn)}.json")
  end

  def author(key)
    self.class.get("#{key}.json")
  end

  def book(key)
    self.class.get("#{key}.json")
  end

  private

  def isbn_cleaner(isbn)
    isbn.upcase.gsub(/[^0-9A-Z]/, '')
  end
end

