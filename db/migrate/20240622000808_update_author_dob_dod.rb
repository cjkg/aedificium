class UpdateAuthorDobDod < ActiveRecord::Migration[7.1]
  def change
    rename_column :authors, :year_of_birth, :date_of_birth
    rename_column :authors, :year_of_death, :date_of_death

    remove_foreign_key :book_authors, :authors
    add_foreign_key :book_authors, :authors, on_delete: :cascade
    remove_foreign_key :book_authors, :books
    add_foreign_key :book_authors, :books, on_delete: :cascade
  end
end
