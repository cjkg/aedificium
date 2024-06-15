class AddDescToRoom < ActiveRecord::Migration[7.1]
  def change
    add_column :rooms, :description, :text
  end
end
