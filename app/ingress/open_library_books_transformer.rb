# frozen_string_literal: true
#
class OpenLibraryBooksTransformer < BaseTransformer
  require "./lib/clients/open_library_books_api.rb"

  def initialize
    @api = OpenLibraryBooksApi.new
  end

  def transform_isbn(isbn)
    isbn = isbn_cleaner(isbn)

    book_key = @api.isbn(isbn).parsed_response["key"]

    if book_key.nil?
      pp "Book not found in Open Library"
      return {},[{}]
    end

    book_info = @api.basic_call(book_key).parsed_response

    book = {}

    book[:title] = book_info["title"]

    book[:isbn_10] = book_info["isbn_10"]&.first || ""
    book[:isbn_13] = book_info["isbn_13"]&.first || source_to_isbn_13(book_info.dig("source_records")) || "" # TODO absolutely has to be a better way to do this

    book_candidates = Book.where(title: book[:title], isbn_10: isbn).or(Book.where(title: book[:title], isbn_13: isbn))

    book[:copy] = book_candidates.length + 1

    # Edition data

    book[:subtitle] = book_info["subtitle"] || ""

    language = ""

    if book_info["languages"].present?
      language_key = book_info["languages"]&.first["key"]
      language_response = @api.basic_call(language_key).parsed_response
      language = language_response["name"]
    end

    book[:language] = language

    book[:publishers] = array_to_string_list(book_info["publishers"]) || ""
    book[:published] = book_info["publish_date"] || ""
    book[:location] = book_info["publish_places"]&.first || ""

    book[:format] = book_info["physical_format"] || ""
    book[:edition] = book_info["edition_name"] || ""

    if book_info["number_of_pages"].present?
      book[:pages] = book_info["number_of_pages"]&.to_i > 0 ? book_info["number_of_pages"].to_s : book[:pages] = ""
    else
      book[:pages] = ""
    end

    goodreads_id = book_info.dig("identifiers", "goodreads")&.first
    book[:goodreads_url] = goodreads_id.present? ? "https://www.goodreads.com/book/show/#{goodreads_id}" : ""

    librarything_id = book_info.dig("identifiers", "librarything")&.first
    book[:librarything_url] =  librarything_id.present? ? "https://www.librarything.com/work/#{librarything_id}" : ""

    # Work data

    works_key = book_info["works"]&.first["key"]

    works_info = @api.basic_call(works_key).parsed_response

    author_keys = works_info["authors"]

    authors = []

    author_keys.each do |ak|
      current_key_string = ak["author"]["key"]
      author_response = @api.basic_call(current_key_string).parsed_response

      author = {}
      author[:name] = author_response["name"] || author_response["personal_name"] || ""
      author[:dob] = author_response["birth_date"] || ""
      author[:dod] = author_response["death_date"] || ""

      # TODO get this working:
      begin
        bio = eval(bio)["value"] || "" # Sometimes it returns JSON, sometimes just a string
      rescue NameError, TypeError
        bio = author_response["bio"] || ""
      end

      authors << author
    end
    return book, authors
  end

  private

  def source_to_isbn_13(source_ary)
    ary_of_split_data = source_ary.map { |x| x.split(":") }

    ary_of_split_data.each do |ary|
      return ary&.last if ary&.first == "idb"
    end

    nil
  end

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