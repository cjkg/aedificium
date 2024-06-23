class AddSubtitle < ActiveRecord::Migration[7.1]
  def change
    add_column :books, :subtitle, :text
  end
end
