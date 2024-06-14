class StartingForth < ActiveRecord::Migration[7.1]
  def change
    create_table :authors do |t|
      t.string :last_name
      t.string :first_name, null: false
      t.integer :year_of_birth
      t.integer :year_of_death

      t.timestamps
    end

    create_table :books do |t|
      t.belongs_to :author, index: true
      t.text :title, null: false
      t.string :ISBN
      t.string :year
      t.string :publisher
      t.string :location
      t.string :format
      t.integer :pages
      t.string :language
      t.string :original_language
      t.string :translator
      t.string :editor
      t.string :edition
      t.integer :rating
      t.text :blurb
      t.text :notes
      t.boolean :available, default: true
      t.boolean :forbidden, default: false
      t.boolean :favorite, default: false

      t.timestamps
    end
  end
end
