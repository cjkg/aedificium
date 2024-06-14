# frozen_string_literal: true

class Book < ApplicationRecord
  belongs_to :author

  validates :title, presence: true
  validates :author, presence: true

  # TODO implement scope same_author
  # TODO implement scope same_genre
  # TODO implement scope same_label
  # TODO implement scope same_shelf

  def is_new?
    # TODO implement
  end

  def random_books
    # TODO implement
  end
end
