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

ActiveRecord::Schema[8.1].define(version: 2026_05_21_211300) do
  create_table "documents", force: :cascade do |t|
    t.boolean "archived", default: false, null: false
    t.json "content", default: {}, null: false
    t.datetime "created_at", null: false
    t.string "paper_style", default: "ruled", null: false
    t.string "title", default: "Documento sem titulo", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id", "updated_at"], name: "index_documents_on_user_id_and_updated_at"
    t.index ["user_id"], name: "index_documents_on_user_id"
  end

  create_table "favorites", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "document_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["document_id"], name: "index_favorites_on_document_id"
    t.index ["user_id", "document_id"], name: "index_favorites_on_user_id_and_document_id", unique: true
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "privacy_requests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "notes"
    t.string "request_type", null: false
    t.string "status", default: "pending", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id", "request_type", "created_at"], name: "idx_on_user_id_request_type_created_at_62e2a38d53"
    t.index ["user_id"], name: "index_privacy_requests_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.boolean "accepted_terms", default: false, null: false
    t.datetime "accepted_terms_at"
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "full_name", null: false
    t.datetime "last_sign_in_at"
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "documents", "users"
  add_foreign_key "favorites", "documents"
  add_foreign_key "favorites", "users"
  add_foreign_key "privacy_requests", "users"
end
