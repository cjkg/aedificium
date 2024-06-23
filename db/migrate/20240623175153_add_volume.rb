class AddVolume < ActiveRecord::Migration[7.1]
  def change
    add_column :books, :volume, :string
  end
end
