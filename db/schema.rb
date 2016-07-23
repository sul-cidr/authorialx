# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160522235541) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "areas", primary_key: "area_id", force: :cascade do |t|
    t.string   "prefname"
    t.string   "area_type"
    t.text     "geom_poly_wkt"
    t.text     "geom_point_wkt"
    t.jsonb    "keywords"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "areas", ["geom_poly_wkt"], name: "idx_areas_geompoly", using: :btree

  create_table "author_category_rels", force: :cascade do |t|
    t.integer  "author_id"
    t.integer  "category_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "author_category_rels", ["author_id", "category_id"], name: "index_author_category_rels_on_author_id_and_category_id", using: :btree
  add_index "author_category_rels", ["category_id", "author_id"], name: "index_author_category_rels_on_category_id_and_author_id", using: :btree

  create_table "author_image_rels", force: :cascade do |t|
    t.integer  "author_id"
    t.integer  "image_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "author_image_rels", ["author_id", "image_id"], name: "index_author_image_rels_on_author_id_and_image_id", using: :btree
  add_index "author_image_rels", ["image_id", "author_id"], name: "index_author_image_rels_on_image_id_and_author_id", using: :btree

  create_table "authors", primary_key: "author_id", force: :cascade do |t|
    t.string   "prefname"
    t.string   "label"
    t.string   "surname"
    t.string   "middle"
    t.string   "given"
    t.date     "birth_date"
    t.date     "death_date"
    t.integer  "birth_year"
    t.integer  "death_year"
    t.integer  "viaf_id"
    t.string   "wiki_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "categories", primary_key: "category_id", force: :cascade do |t|
    t.string   "name"
    t.integer  "dimension_id"
    t.integer  "sort"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "communities", id: false, force: :cascade do |t|
    t.integer  "community_id"
    t.string   "name"
    t.integer  "start_earliest"
    t.integer  "start_latest"
    t.integer  "stop_earliest"
    t.integer  "stop_latest"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "dimensions", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "forms", primary_key: "form_id", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "genres", primary_key: "genre_id", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "images", force: :cascade do |t|
    t.integer  "image_id"
    t.string   "filename"
    t.integer  "place_id"
    t.integer  "author_id"
    t.integer  "placeref_id"
    t.string   "label"
    t.text     "caption"
    t.text     "geom_wkt"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "passages", primary_key: "passage_id", force: :cascade do |t|
    t.integer  "work_id"
    t.integer  "subject_id"
    t.text     "text"
    t.string   "placerefs",  default: [],              array: true
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "placenames", primary_key: "placename_id", force: :cascade do |t|
    t.string   "placename"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "placerefs", force: :cascade do |t|
    t.integer  "placeref_id",   null: false
    t.integer  "work_id"
    t.integer  "year"
    t.string   "passage_id",    null: false
    t.string   "placeref"
    t.integer  "author_id"
    t.integer  "place_id"
    t.string   "placeref_type"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "placerefs", ["placeref_id", "passage_id"], name: "placerefs_uniq", unique: true, using: :btree

  create_table "places", primary_key: "place_id", force: :cascade do |t|
    t.string   "prefname"
    t.float    "latitude"
    t.float    "longitude"
    t.text     "geom_wkt"
    t.text     "geom_wkt_l"
    t.text     "geom_wkt_a"
    t.string   "source"
    t.integer  "placerefs_count"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "standings", id: false, force: :cascade do |t|
    t.integer  "standing_id"
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "work_category_rels", force: :cascade do |t|
    t.integer  "work_id"
    t.integer  "category_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "work_category_rels", ["category_id", "work_id"], name: "index_work_category_rels_on_category_id_and_work_id", using: :btree
  add_index "work_category_rels", ["work_id", "category_id"], name: "index_work_category_rels_on_work_id_and_category_id", using: :btree

  create_table "works", primary_key: "work_id", force: :cascade do |t|
    t.integer  "author_id"
    t.string   "title"
    t.string   "sorter"
    t.integer  "work_year"
    t.jsonb    "keywords"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
