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

ActiveRecord::Schema.define(version: 2022_01_12_232611) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
  enable_extension "pg_stat_statements"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "posts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "content", limit: 256, null: false
    t.string "origin_ip", limit: 45, null: false
    t.string "title", limit: 256, null: false
    t.uuid "user_id", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "average_rate"
    t.index "lower((title)::text)", name: "index_posts_on_lower_title", unique: true, where: "(deleted_at IS NULL)"
    t.index ["user_id"], name: "index_posts_on_user_id"
    t.check_constraint "(average_rate >= (1)::double precision) AND (average_rate <= (5)::double precision)", name: "check_average_rate_range"
  end

  create_table "ratings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "rate", null: false
    t.uuid "post_id", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["post_id"], name: "index_ratings_on_post_id"
    t.check_constraint "(rate >= 1) AND (rate <= 5)", name: "check_rate_range"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", limit: 254, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index "lower((email)::text)", name: "index_users_on_lower_email", unique: true, where: "(deleted_at IS NULL)"
  end

  add_foreign_key "posts", "users"
  add_foreign_key "ratings", "posts"
end
