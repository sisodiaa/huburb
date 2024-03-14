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

ActiveRecord::Schema.define(version: 20170612105214) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"
  enable_extension "uuid-ossp"

  create_table "ad_viewers", id: :serial, force: :cascade do |t|
    t.integer "view", default: 0
    t.integer "click", default: 0
    t.integer "viewer_id"
    t.uuid "ad_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ad_id"], name: "index_ad_viewers_on_ad_id"
    t.index ["viewer_id", "ad_id"], name: "index_ad_viewers_on_viewer_id_and_ad_id", unique: true
    t.index ["viewer_id"], name: "index_ad_viewers_on_viewer_id"
  end

  create_table "addresses", id: :serial, force: :cascade do |t|
    t.string "pincode"
    t.string "city"
    t.string "state"
    t.string "country"
    t.text "line1"
    t.text "line2"
    t.geography "location", limit: {:srid=>4326, :type=>"st_point", :geographic=>true}, null: false
    t.string "locatable_type"
    t.integer "locatable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["locatable_type", "locatable_id"], name: "index_addresses_on_locatable_type_and_locatable_id"
    t.index ["location"], name: "index_addresses_on_location", using: :gist
  end

  create_table "admins", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "advertisements", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "headline"
    t.string "body"
    t.string "url"
    t.datetime "published_at"
    t.integer "status", default: 0
    t.integer "page_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "duration", default: 1
    t.geography "location", limit: {:srid=>4326, :type=>"st_point", :geographic=>true}
    t.index ["location"], name: "index_advertisements_on_location", using: :gist
    t.index ["page_id"], name: "index_advertisements_on_page_id"
  end

  create_table "invitees", id: :serial, force: :cascade do |t|
    t.string "full_name", null: false
    t.string "email", null: false
    t.string "city"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "memberships", id: :serial, force: :cascade do |t|
    t.integer "room_id"
    t.string "memberable_type"
    t.integer "memberable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["memberable_type", "memberable_id"], name: "index_memberships_on_memberable_type_and_memberable_id"
    t.index ["room_id"], name: "index_memberships_on_room_id"
  end

  create_table "messages", id: :serial, force: :cascade do |t|
    t.text "content"
    t.integer "room_id"
    t.string "sender_type"
    t.integer "sender_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_messages_on_room_id"
    t.index ["sender_type", "sender_id"], name: "index_messages_on_sender_type_and_sender_id"
  end

  create_table "pages", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "category", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "pin"
    t.integer "owner_id"
    t.index ["owner_id"], name: "index_pages_on_owner_id"
    t.index ["pin"], name: "index_pages_on_pin", unique: true
  end

  create_table "pictures", id: :serial, force: :cascade do |t|
    t.string "picture"
    t.string "imageable_type"
    t.integer "imageable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["imageable_type", "imageable_id"], name: "index_pictures_on_imageable_type_and_imageable_id"
  end

  create_table "posts", id: :serial, force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.integer "page_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "pinned", default: false
    t.index ["page_id"], name: "index_posts_on_page_id"
  end

  create_table "profiles", id: :serial, force: :cascade do |t|
    t.string "username", null: false
    t.integer "gender", default: 0, null: false
    t.date "date_of_birth", null: false
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.index ["user_id"], name: "index_profiles_on_user_id"
    t.index ["username"], name: "index_profiles_on_username", unique: true
  end

  create_table "rooms", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "ad_viewers", "advertisements", column: "ad_id"
  add_foreign_key "ad_viewers", "users", column: "viewer_id"
  add_foreign_key "advertisements", "pages"
  add_foreign_key "memberships", "rooms"
  add_foreign_key "messages", "rooms"
  add_foreign_key "pages", "users", column: "owner_id"
  add_foreign_key "posts", "pages"
  add_foreign_key "profiles", "users"
end
