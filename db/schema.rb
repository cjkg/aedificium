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

ActiveRecord::Schema[7.1].define(version: 2024_06_14_023343) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authors", force: :cascade do |t|
    t.string "last_name"
    t.string "first_name", null: false
    t.integer "year_of_birth"
    t.integer "year_of_death"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "books", force: :cascade do |t|
    t.bigint "author_id"
    t.text "title", null: false
    t.string "ISBN"
    t.string "year"
    t.string "publisher"
    t.string "location"
    t.string "format"
    t.integer "pages"
    t.string "language"
    t.string "original_language"
    t.string "translator"
    t.string "editor"
    t.string "edition"
    t.integer "rating"
    t.text "blurb"
    t.text "notes"
    t.boolean "available", default: true
    t.boolean "forbidden", default: false
    t.boolean "favorite", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_books_on_author_id"
  end

end
