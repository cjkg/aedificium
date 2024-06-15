class RethinkingBooksAndRooms < ActiveRecord::Migration[7.1]
  def change
    create_table :rooms do |t|
      t.string :name, null: false
      t.string :access, null: false
    end

    add_reference :books, :room, index: true

    remove_column :books, :available, :forbidden
    change_column :books, :year, 'integer USING CAST(year AS integer)'
    change_column :books, :translator, :text
    change_column :books, :editor, :text
  end
end
