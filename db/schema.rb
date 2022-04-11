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

ActiveRecord::Schema[7.0].define(version: 2022_04_11_175218) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "challenge_status", ["draft", "moderation", "pending", "registration", "live", "complete", "canceled"]

  create_table "challenges", force: :cascade do |t|
    t.enum "status", default: "draft", null: false, enum_type: "challenge_status"
    t.citext "title", null: false
    t.citext "slug", null: false
    t.text "description"
    t.text "terms_and_conditions"
    t.datetime "registration_at"
    t.datetime "start_at"
    t.datetime "finish_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_challenges_on_slug", unique: true
    t.index ["status"], name: "index_challenges_on_status"
    t.index ["title"], name: "index_challenges_on_title", unique: true
  end

  create_table "tasks", force: :cascade do |t|
    t.citext "title", null: false
    t.citext "slug", null: false
    t.text "description"
    t.bigint "challenge_id", null: false
    t.datetime "start_at"
    t.datetime "submit_at"
    t.datetime "result_at"
    t.bigint "dependent_task_id"
    t.integer "min_assestment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["challenge_id"], name: "index_tasks_on_challenge_id"
    t.index ["dependent_task_id"], name: "index_tasks_on_dependent_task_id"
    t.index ["slug"], name: "index_tasks_on_slug", unique: true
    t.index ["title"], name: "index_tasks_on_title", unique: true
  end

  create_table "taxonomies", force: :cascade do |t|
    t.citext "title", null: false
    t.citext "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_taxonomies_on_slug", unique: true
    t.index ["title"], name: "index_taxonomies_on_title", unique: true
  end

  create_table "taxons", force: :cascade do |t|
    t.citext "title", null: false
    t.citext "slug", null: false
    t.integer "position"
    t.bigint "taxonomy_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["taxonomy_id", "slug"], name: "index_taxons_on_taxonomy_id_and_slug", unique: true
    t.index ["taxonomy_id", "title"], name: "index_taxons_on_taxonomy_id_and_title", unique: true
    t.index ["taxonomy_id"], name: "index_taxons_on_taxonomy_id"
  end

  create_table "users", force: :cascade do |t|
    t.citext "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.citext "full_name", null: false
    t.citext "slug", null: false
    t.string "time_zone", default: "UTC"
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
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["slug"], name: "index_users_on_slug", unique: true
  end

  add_foreign_key "tasks", "challenges"
  add_foreign_key "tasks", "tasks", column: "dependent_task_id"
  add_foreign_key "taxons", "taxonomies", on_delete: :cascade
end
