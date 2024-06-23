# frozen_string_literal: true
#
class OpenLibraryBooksTransformer < BaseTransformer
  require "./lib/clients/open_library_books_api.rb"

  def initialize
    @api = OpenLibraryBooksApi.new
  end

  def transform_isbn(isbn, room_id)
    isbn = isbn_cleaner(isbn)

    book_key = @api.isbn(isbn).parsed_response["key"]

    if book_key.nil?
      pp "Book not found in Open Library"
      return
    end

    book_info = @api.basic_call(book_key).parsed_response

    title = book_info["title"]

    isbn_10 = book_info["isbn_10"]&.first
    isbn_13 = book_info["isbn_13"]&.first || source_to_isbn_13(book_info.dig("source_records")) # TODO absolutely has to be a better way to do this

    book_candidates = Book.where(title: title, isbn_10: isbn).or(Book.where(title: title, isbn_13: isbn))

    copy = book_candidates.length + 1

    book = Book.new(title: title, isbn_10: isbn_10, isbn_13: isbn_13, copy: copy, room_id: room_id)

    # Edition data

    subtitle = book_info["subtitle"]
    book.update(subtitle: subtitle) if subtitle.present?

    if book_info["languages"].nil?
      pp "Language not found in Open Library"
    else
      language_key = book_info["languages"]&.first["key"]
      language_response = @api.basic_call(language_key).parsed_response
      language = language_response["name"]
      book.update(language: language) if language_response.present?
    end

    publishers = array_to_string_list(book_info["publishers"])
    book.update(publisher: publishers) if publishers.present?

    published = book_info["publish_date"]
    book.update(published: published) if published.present?

    location = book_info["publish_places"]&.first
    book.update(location: location) if location.present?

    format = book_info["physical_format"]
    book.update(format: format) if format.present?

    edition = book_info["edition_name"]
    book.update(edition: edition) if edition.present?

    if book_info["number_of_pages"]&.to_i > 0
      book.update(pages: book_info["number_of_pages"])
    end

    goodreads_id = book_info.dig("identifiers", "goodreads")&.first
    book.update(goodreads_id: goodreads_id) if goodreads_id.present?

    librarything_id = book_info.dig("identifiers", "librarything")&.first
    book.update(librarything_id: librarything_id) if librarything_id.present?

    unless book.save
      pp book.errors.messages
      return
    end

    # Work data

    works_key = book_info["works"]&.first["key"]

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
        pp "bio not a ruby object -- using raw bio instead"
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