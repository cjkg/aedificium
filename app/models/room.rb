class Room < ApplicationRecord
  has_many :books

  validates :name, presence: true
  validates :access, presence: true, inclusion: { :in => %w[forbidden restricted open]}
end