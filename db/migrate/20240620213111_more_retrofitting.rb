class MoreRetrofitting < ActiveRecord::Migration[7.1]
  def change
    add_column :books, :copy, :integer
    rename_column :books, :ISBN, :isbn
  end
end
