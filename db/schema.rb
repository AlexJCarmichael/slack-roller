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

ActiveRecord::Schema.define(version: 20161018221842) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "characters", force: :cascade do |t|
    t.string   "char_name",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "user_name"
  end

  create_table "messages", force: :cascade do |t|
    t.string   "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "user_name"
  end

  create_table "mods", force: :cascade do |t|
    t.integer  "character_id"
    t.integer  "weapon_mod"
    t.integer  "armor_mod"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["character_id"], name: "index_mods_on_character_id", using: :btree
  end

  create_table "stats", force: :cascade do |t|
    t.integer  "character_id"
    t.integer  "str",          null: false
    t.integer  "dex",          null: false
    t.integer  "con",          null: false
    t.integer  "int",          null: false
    t.integer  "wis",          null: false
    t.integer  "cha",          null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["character_id"], name: "index_stats_on_character_id", using: :btree
  end

  add_foreign_key "mods", "characters"
  add_foreign_key "stats", "characters"
end
