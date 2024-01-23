class CreateComments < ActiveRecord::Migration
  def change
    create_table "comments", force: :cascade do |t|
      t.integer "review_id"
      t.string  "author_name"
      t.text    "content"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end

    add_foreign_key "comments", "reviews", column: "review_id", on_delete: :cascade
  end
end
