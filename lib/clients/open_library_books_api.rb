# frozen_string_literal: true
# lib/clients/open_library_books_api.rb

class OpenLibraryBooksApi
  include HTTParty
  base_uri 'https://openlibrary.org'

  def initialize
  end

  def isbn(isbn)
    self.class.get("/isbn/#{isbn}.json")
  end

  def basic_call(key)
    self.class.get("#{key}.json")
  end
end

