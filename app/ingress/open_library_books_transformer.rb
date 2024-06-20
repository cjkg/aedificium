# frozen_string_literal: true
#
class OpenLibraryBooksTransformer < BaseTransformer
  require "./lib/clients/open_library_books_api.rb"

  def initialize
    @api = OpenLibraryBooksApi.new
  end

  def transform_isbn(isbn)
    @api.isbn(isbn).parsed_response
    authors_key = book_info["authors"].map { |author| author["key"] }

    authors_key.each do |key|
      author_info = @api.author(key)
      name = author_info["name"]
      Author.find_or_create_by(name: author_info["name"])
    end


    # authors_key.each do |key|
    #  author_info = @api.author(key)

    #  author = Author.find_or_create_by(first_name: author_info["name"])
    #  author.update(last_name: author_info["last_name"])
    # end
    # publishers = JSON.parse(book_info["publishers"])
    # authors_key
  end
end
