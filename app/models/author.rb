# frozen string literal: true

class Author < ApplicationRecord
  has_many :books
end