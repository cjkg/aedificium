# frozen_string_literal: true

class Book < ApplicationRecord
  belongs_to :author
  belongs_to :room

  validates :title, presence: true

  # TODO implement scope same_author
  # TODO implement scope same_genre
  # TODO implement scope same_label
  # TODO implement scope same_shelf

  # is new?
  # random
  # available?
end
