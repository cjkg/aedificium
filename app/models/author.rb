# frozen string literal: true

class Author < ApplicationRecord
  has_many :books

  validates :first_name, presence: true

  def author_first_last
    last_name = self.last_name.present? ? " " + self.last_name : ""
    self.first_name + last_name
  end
end