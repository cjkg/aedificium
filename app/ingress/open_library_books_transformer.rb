# frozen_string_literal: true
#
class OpenLibraryBooksTransformer < BaseTransformer
  require "./lib/clients/open_library_books_api.rb"

  def initialize
    @api = OpenLibraryBooksApi.new
  end

  def transform_isbn(isbn, room_id)
    isbn = isbn_cleaner(isbn)
    book_info = @api.isbn(isbn).parsed_response
    title = book_info["title"]

    book_candidates = Book.where(title: title, isbn: isbn)
    copy = book_candidates.length + 1

    book = Book.new(title: title, isbn: isbn, copy: copy, room_id: room_id)

    unless book.save
      pp book.errors.messages
      return
    end

    publishers = book_info["publishers"]
    pages = book_info["number_of_pages"]

    works_key = book_info["works"].first["key"]

    works_info = @api.basic_call(works_key).parsed_response

    author_keys = works_info["authors"]

    author_keys.each do |ak|
      current_key_string = ak["author"]["key"]
      author_response = @api.basic_call(current_key_string).parsed_response

      name = author_response["name"] || author_response["personal_name"]
      dob = author_response["birth_date"]

      author = Author.find_or_create_by(name: name, date_of_birth: dob)

      dod = author_response["death_date"]
      author.update(date_of_death: dod) if author.date_of_death.nil?

      bio = author_response["bio"] || ""

      # TODO get this working:
      begin
        bio = eval(bio)["value"] # Sometimes it returns a stringified ruby object (!?!) instead of a string?
      rescue NameError, TypeError
        pp "Error parsing raw_bio -- using raw bio instead"
      end

      author.update(bio: bio) if author.bio.nil?

      unless author.save
        pp author.errors.messages
        return
      end

      book_author_pair = BookAuthor.find_or_initialize_by(book_id: book.id, author_id: author.id)

      unless book_author_pair.save
        pp book_author_pair.errors.messages
        return
      end
    end
  end

  private

  def build_book(book_info)
    book_info = @api.isbn(isbn).parsed_response
  end

  def build_authors(authors_info)
    # implement
  end

  def build_book_author(book_id, author_ids)
    # implement
  end
end