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

ActiveRecord::Schema.define(version: 20161019225458) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "actor_characters", force: :cascade do |t|
    t.integer  "character_id"
    t.integer  "actor_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["actor_id"], name: "index_actor_characters_on_actor_id", using: :btree
    t.index ["character_id"], name: "index_actor_characters_on_character_id", using: :btree
  end

  create_table "actors", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "character_modifiers", force: :cascade do |t|
    t.integer  "character_id"
    t.integer  "modifier_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["character_id"], name: "index_character_modifiers_on_character_id", using: :btree
    t.index ["modifier_id"], name: "index_character_modifiers_on_modifier_id", using: :btree
  end

  create_table "character_stats", force: :cascade do |t|
    t.integer  "character_id"
    t.integer  "stat_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["character_id"], name: "index_character_stats_on_character_id", using: :btree
    t.index ["stat_id"], name: "index_character_stats_on_stat_id", using: :btree
  end

  create_table "characters", force: :cascade do |t|
    t.string   "name",       null: false
    t.integer  "actor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["actor_id"], name: "index_characters_on_actor_id", using: :btree
  end

  create_table "current_actors", force: :cascade do |t|
    t.integer  "character_id"
    t.integer  "actor_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["actor_id"], name: "index_current_actors_on_actor_id", using: :btree
    t.index ["character_id"], name: "index_current_actors_on_character_id", using: :btree
  end

  create_table "messages", force: :cascade do |t|
    t.string   "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "user_name"
  end

  create_table "modifiers", force: :cascade do |t|
    t.string   "name"
    t.integer  "value",      default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "stats", force: :cascade do |t|
    t.string   "name"
    t.integer  "value",      default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_foreign_key "actor_characters", "actors"
  add_foreign_key "actor_characters", "characters"
  add_foreign_key "character_modifiers", "characters"
  add_foreign_key "character_modifiers", "modifiers"
  add_foreign_key "character_stats", "characters"
  add_foreign_key "character_stats", "stats"
  add_foreign_key "current_actors", "actors"
  add_foreign_key "current_actors", "characters"
end
