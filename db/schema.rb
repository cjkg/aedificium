# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_06_20_011618) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authors", force: :cascade do |t|
    t.string "year_of_birth"
    t.string "year_of_death"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.text "bio"
  end

  create_table "book_authors", force: :cascade do |t|
    t.bigint "book_id", null: false
    t.bigint "author_id", null: false
    t.index ["author_id"], name: "index_book_authors_on_author_id"
    t.index ["book_id"], name: "index_book_authors_on_book_id"
  end

  create_table "books", force: :cascade do |t|
    t.text "title", null: false
    t.string "ISBN"
    t.string "publisher"
    t.string "location"
    t.string "format"
    t.integer "pages"
    t.string "language"
    t.string "original_language"
    t.text "translator"
    t.text "editor"
    t.text "edition"
    t.integer "rating"
    t.text "blurb"
    t.text "notes"
    t.boolean "forbidden", default: false
    t.boolean "favorite", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "room_id"
    t.string "published"
    t.integer "goodreads_id"
    t.integer "librarything_id"
    t.text "series"
    t.text "subjects"
    t.index ["room_id"], name: "index_books_on_room_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name", null: false
    t.string "access", null: false
    t.text "description"
  end

  add_foreign_key "book_authors", "authors"
  add_foreign_key "book_authors", "books"
end
