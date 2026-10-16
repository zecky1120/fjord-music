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

ActiveRecord::Schema[8.1].define(version: 2026_08_20_110153) do
  create_table "users", force: :cascade do |t|
    t.string "avatar_url"
    t.datetime "created_at", null: false
    t.string "name"
    t.string "nickname"
    t.string "provider"
    t.string "uid"
    t.datetime "updated_at", null: false
  end

  create_table "videos", force: :cascade do |t|
    t.text "caption"
    t.datetime "created_at", null: false
    t.string "discord_channel_id"
    t.string "discord_message_id"
    t.string "thumbnail"
    t.string "title"
    t.datetime "updated_at", null: false
    t.string "url"
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_videos_on_user_id"
  end

  add_foreign_key "videos", "users"
end
