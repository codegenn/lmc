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

ActiveRecord::Schema.define(version: 20221012023959) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
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
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "applications", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone_number"
    t.string   "cv_file_name"
    t.string   "cv_content_type"
    t.integer  "cv_file_size",    limit: 8
    t.datetime "cv_updated_at"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "job_id"
  end

  add_index "applications", ["job_id"], name: "index_applications_on_job_id", using: :btree

  create_table "ar_internal_metadata", primary_key: "key", force: :cascade do |t|
    t.string   "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bottom_stocks", force: :cascade do |t|
    t.integer "product_id"
    t.string  "size"
  end

  create_table "carts", force: :cascade do |t|
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "voucher_code"
  end

  create_table "categories", force: :cascade do |t|
    t.integer  "sort_order"
    t.string   "measurement_image_url"
    t.string   "image_url"
    t.string   "banner_url"
    t.string   "slug"
    t.string   "slug_url"
    t.string   "measurement_image_file_name"
    t.string   "measurement_image_content_type"
    t.integer  "measurement_image_file_size",    limit: 8
    t.datetime "measurement_image_updated_at"
    t.string   "category_image_file_name"
    t.string   "category_image_content_type"
    t.integer  "category_image_file_size",       limit: 8
    t.datetime "category_image_updated_at"
    t.string   "banner_file_name"
    t.string   "banner_content_type"
    t.integer  "banner_file_size",               limit: 8
    t.datetime "banner_updated_at"
  end

  add_index "categories", ["slug"], name: "index_categories_on_slug", unique: true, using: :btree

  create_table "category_products", force: :cascade do |t|
    t.integer "product_id"
    t.integer "category_id"
  end

  create_table "category_translations", force: :cascade do |t|
    t.integer  "category_id", null: false
    t.string   "locale",      null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "name"
    t.string   "description"
  end

  add_index "category_translations", ["category_id"], name: "index_category_translations_on_category_id", using: :btree
  add_index "category_translations", ["locale"], name: "index_category_translations_on_locale", using: :btree

  create_table "color_images", force: :cascade do |t|
    t.integer  "product_id"
    t.string   "image_url"
    t.string   "color_name"
    t.string   "color_image_file_name"
    t.string   "color_image_content_type"
    t.integer  "color_image_file_size",    limit: 8
    t.datetime "color_image_updated_at"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "favorite_products", force: :cascade do |t|
    t.integer "product_id"
    t.integer "favorite_id"
  end

  create_table "favorites", force: :cascade do |t|
    t.string  "code"
    t.integer "user_id"
  end

  create_table "foundations", force: :cascade do |t|
    t.string   "author"
    t.string   "title"
    t.text     "short_description"
    t.text     "content"
    t.string   "image"
    t.string   "category"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "slug"
    t.string   "slug_url"
    t.string   "foundation_image_file_name"
    t.string   "foundation_image_content_type"
    t.integer  "foundation_image_file_size",    limit: 8
    t.datetime "foundation_image_updated_at"
  end

  add_index "foundations", ["slug"], name: "index_foundations_on_slug", unique: true, using: :btree

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id", using: :btree

  create_table "jobs", force: :cascade do |t|
    t.string   "title"
    t.text     "short_description"
    t.text     "content"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "line_items", force: :cascade do |t|
    t.integer  "stock_id"
    t.integer  "cart_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quantity",        default: 0
    t.integer  "order_id"
    t.float    "price"
    t.integer  "bottom_stock_id"
  end

  add_index "line_items", ["bottom_stock_id"], name: "index_line_items_on_bottom_stock_id", using: :btree
  add_index "line_items", ["cart_id"], name: "index_line_items_on_cart_id", using: :btree
  add_index "line_items", ["order_id"], name: "index_line_items_on_order_id", using: :btree
  add_index "line_items", ["stock_id"], name: "index_line_items_on_stock_id", using: :btree

  create_table "mautic_connections", force: :cascade do |t|
    t.string   "type"
    t.string   "url"
    t.string   "client_id"
    t.string   "secret"
    t.string   "token"
    t.string   "refresh_token"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "measurements", force: :cascade do |t|
    t.integer "category_id"
    t.string  "size"
    t.string  "bust"
    t.boolean "waist"
    t.boolean "length"
    t.boolean "sleeve_length"
    t.boolean "sleeve_circumference"
  end

  create_table "media", force: :cascade do |t|
    t.string   "media_image_content_type"
    t.string   "url"
    t.string   "media_image_file_name"
    t.string   "alt"
    t.string   "media_image"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "messages", force: :cascade do |t|
    t.string   "email"
    t.string   "question"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone"
    t.string   "city"
    t.string   "district"
    t.string   "note"
    t.text     "address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tracking"
    t.string   "status"
    t.string   "payment_method"
    t.float    "sub_total_price"
    t.float    "grand_total"
    t.string   "voucher_code"
    t.string   "payment_status"
  end

  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

  create_table "partners", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "alt"
    t.string   "url"
    t.string   "partner_image"
    t.string   "partner_image_file_name"
    t.string   "partner_image_content_type"
  end

  create_table "product_images", force: :cascade do |t|
    t.integer  "product_id"
    t.string   "url"
    t.string   "pimage_file_name"
    t.string   "pimage_content_type"
    t.integer  "pimage_file_size",    limit: 8
    t.datetime "pimage_updated_at"
  end

  create_table "product_translations", force: :cascade do |t|
    t.integer  "product_id",              null: false
    t.string   "locale",                  null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "title"
    t.text     "short_description"
    t.text     "description"
    t.string   "promotion"
    t.text     "measurement_description"
  end

  add_index "product_translations", ["locale"], name: "index_product_translations_on_locale", using: :btree
  add_index "product_translations", ["product_id"], name: "index_product_translations_on_product_id", using: :btree

  create_table "products", force: :cascade do |t|
    t.float    "price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_best_seller",                           default: false
    t.boolean  "is_promotion",                             default: false
    t.boolean  "is_new_arrival",                           default: false
    t.boolean  "has_promotion",                            default: false
    t.string   "promotion"
    t.string   "measurement_image_url"
    t.string   "slug"
    t.string   "slug_url"
    t.boolean  "out_of_stock",                             default: false
    t.float    "promotion_price"
    t.integer  "sort_order",                               default: 0
    t.string   "measurement_image_file_name"
    t.string   "measurement_image_content_type"
    t.integer  "measurement_image_file_size",    limit: 8
    t.datetime "measurement_image_updated_at"
    t.boolean  "is_hidden",                                default: false
    t.integer  "stock"
  end

  add_index "products", ["slug"], name: "index_products_on_slug", unique: true, using: :btree

  create_table "stocks", force: :cascade do |t|
    t.integer "product_id"
    t.string  "size"
    t.string  "color"
    t.boolean "in_stock"
    t.string  "product_code"
    t.integer "quantity"
  end

  create_table "subscribers", force: :cascade do |t|
    t.string "email"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "first_name",             default: "", null: false
    t.string   "last_name",              default: "", null: false
    t.integer  "phone",                               null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "provider"
    t.string   "uid"
    t.string   "username"
    t.string   "avatar"
    t.datetime "dob"
    t.integer  "code_kiot"
    t.string   "kiot_id"
    t.string   "address"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "vouchers", force: :cascade do |t|
    t.string  "code"
    t.string  "voucher_type"
    t.boolean "active"
    t.boolean "one_time_use", default: false
  end

end
