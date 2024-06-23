class UpdateIsbns < ActiveRecord::Migration[7.1]
  def change
    rename_column :books, :isbn, :isbn_10
    add_column :books, :isbn_13, :string
  end
end
