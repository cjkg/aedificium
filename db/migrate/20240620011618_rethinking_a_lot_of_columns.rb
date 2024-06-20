class RethinkingALotOfColumns < ActiveRecord::Migration[7.1]
  def change
    remove_column :authors, :first_name, :string
    remove_column :authors, :last_name, :string
    add_column :authors, :name, :string
    add_column :authors, :bio, :text
    change_column :authors, :year_of_birth, :string
    change_column :authors, :year_of_death, :string

    remove_column :books, :author_id, :bigint
    remove_column :books, :year, :integer
    add_column :books, :published, :string
    add_column :books, :goodreads_id, :integer
    add_column :books, :librarything_id, :integer
    add_column :books, :series, :text
    add_column :books, :subjects, :text
    change_column :books, :edition, :text

    create_table :book_authors do |t|
      t.references :book, null: false, foreign_key: true
      t.references :author, null: false, foreign_key: true
    end
  end
end
