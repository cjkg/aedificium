# frozen_string_literal: true

class OpenLibraryBooksApi
  include HTTParty
  base_uri 'https://openlibrary.org'

  def initialize
  end

  def isbn(isbn)
    self.class.get("/isbn/#{isbn}.json")
  end

  def author(key)
    self.class.get("#{key}.json")
  end

  def book(key)
    self.class.get("#{key}.json")
  end
end

