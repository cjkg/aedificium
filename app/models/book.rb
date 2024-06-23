# frozen_string_literal: true

class Book < ApplicationRecord
  has_many :book_authors
  has_many :authors, through: :book_authors
  belongs_to :room

  validates :title, presence: true

  # TODO implement scope same_author
  # TODO implement scope same_genre
  # TODO implement scope same_label
  # TODO implement scope same_shelf

  # is new?
  # random
  # available?

  def author?
    authors.length > 0
  end

  def multiple_authors?
    authors.length > 1
  end

  def subtitle?
    subtitle.present?
  end

  def full_authors_display
    if multiple_authors?
      authors.map(&:name).join(", ")
    elsif author?
      authors&.first&.name
    else
      "Unknown"
    end
  end

  def short_authors_display
    if multiple_authors?
      authors&.first&.name + " et al."
    elsif author?
      authors&.first&.name
    else
      "Unknown"
    end
  end

  def full_title_display
    subtitle? ? "#{title}: #{subtitle}" : title
  end

  def short_title_display
    full_title_display.length > 50 ? "#{full_title_display[0..50]}..." : full_title_display
  end

  def short_author_title_display
    "#{short_authors_display} - #{short_title_display}"
  end
end
