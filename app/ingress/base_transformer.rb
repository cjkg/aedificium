# frozen_string_literal: true

class BaseTransformer
  def isbn_cleaner(isbn)
    isbn.gsub("-", "").gsub(" ", "")
  end

  def array_to_string_list(array)
    array.join(", ")
  end

  def new_line_remover(str)
    str.split("\n").map(&:strip).join(" ")
  end
end
