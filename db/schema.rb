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

ActiveRecord::Schema[7.0].define(version: 2022_11_14_142518) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "challenge_status", ["draft", "moderation", "ready", "canceled", "completed"]
  create_enum "member_role", ["participant", "judge"]

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

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
    t.string "remote_email_group_id"
    t.bigint "vendor_id"
    t.index ["slug"], name: "index_challenges_on_slug", unique: true
    t.index ["status"], name: "index_challenges_on_status"
    t.index ["title"], name: "index_challenges_on_title", unique: true
    t.index ["vendor_id"], name: "index_challenges_on_vendor_id"
  end

  create_table "members", force: :cascade do |t|
    t.enum "role", default: "participant", null: false, enum_type: "member_role"
    t.bigint "user_id"
    t.bigint "challenge_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["challenge_id"], name: "index_members_on_challenge_id"
    t.index ["role"], name: "index_members_on_role"
    t.index ["user_id"], name: "index_members_on_user_id"
  end

  create_table "task_assessments", force: :cascade do |t|
    t.integer "value", default: 0, null: false
    t.text "comment"
    t.bigint "judge_id", null: false
    t.bigint "task_criterium_id", null: false
    t.bigint "task_submission_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["judge_id", "task_criterium_id", "task_submission_id"], name: "unique_index_for_task_assesments", unique: true
    t.index ["judge_id"], name: "index_task_assessments_on_judge_id"
    t.index ["task_criterium_id"], name: "index_task_assessments_on_task_criterium_id"
    t.index ["task_submission_id"], name: "index_task_assessments_on_task_submission_id"
  end

  create_table "task_criteria", force: :cascade do |t|
    t.string "title"
    t.integer "max_value", default: 0, null: false
    t.bigint "task_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["task_id"], name: "index_task_criteria_on_task_id"
  end

  create_table "task_submission_judges", force: :cascade do |t|
    t.bigint "task_submission_id", null: false
    t.bigint "judge_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["judge_id"], name: "index_task_submission_judges_on_judge_id"
    t.index ["task_submission_id"], name: "index_task_submission_judges_on_task_submission_id"
  end

  create_table "task_submissions", force: :cascade do |t|
    t.bigint "task_id", null: false
    t.bigint "member_id", null: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "judge_id"
    t.index ["judge_id"], name: "index_task_submissions_on_judge_id"
    t.index ["member_id"], name: "index_task_submissions_on_member_id"
    t.index ["task_id", "member_id"], name: "index_task_submissions_on_task_id_and_member_id", unique: true
    t.index ["task_id"], name: "index_task_submissions_on_task_id"
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
    t.integer "min_assessment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "require_attachment", default: false
    t.boolean "show_instant_result", default: false, null: false
    t.index ["challenge_id"], name: "index_tasks_on_challenge_id"
    t.index ["dependent_task_id"], name: "index_tasks_on_dependent_task_id"
    t.index ["slug", "challenge_id"], name: "index_tasks_on_slug_and_challenge_id", unique: true
    t.index ["title", "challenge_id"], name: "index_tasks_on_title_and_challenge_id", unique: true
  end

  create_table "taxon_entities", force: :cascade do |t|
    t.bigint "taxon_id", null: false
    t.integer "entity_id", null: false
    t.string "entity_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["taxon_id", "entity_id", "entity_type"], name: "index_taxon_entities_on_taxon_id_and_entity_id_and_entity_type", unique: true
    t.index ["taxon_id"], name: "index_taxon_entities_on_taxon_id"
  end

  create_table "taxonomies", force: :cascade do |t|
    t.citext "title", null: false
    t.citext "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_taxonomies_on_slug", unique: true
    t.index ["title"], name: "index_taxonomies_on_title", unique: true
  end

  create_table "taxonomy_repos", force: :cascade do |t|
    t.bigint "taxonomy_id", null: false
    t.string "repo", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["taxonomy_id", "repo"], name: "index_taxonomy_repos_on_taxonomy_id_and_repo", unique: true
    t.index ["taxonomy_id"], name: "index_taxonomy_repos_on_taxonomy_id"
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
    t.string "provider"
    t.string "uid"
    t.string "legacy_id"
    t.string "phone_number"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["slug"], name: "index_users_on_slug", unique: true
  end

  create_table "vendors", force: :cascade do |t|
    t.citext "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_vendors_on_name", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "members", "challenges"
  add_foreign_key "members", "users"
  add_foreign_key "task_assessments", "members", column: "judge_id"
  add_foreign_key "task_assessments", "task_criteria"
  add_foreign_key "task_assessments", "task_submissions"
  add_foreign_key "task_criteria", "tasks"
  add_foreign_key "task_submission_judges", "members", column: "judge_id", on_delete: :cascade
  add_foreign_key "task_submission_judges", "task_submissions", on_delete: :cascade
  add_foreign_key "task_submissions", "members"
  add_foreign_key "task_submissions", "members", column: "judge_id"
  add_foreign_key "task_submissions", "tasks"
  add_foreign_key "tasks", "challenges"
  add_foreign_key "tasks", "tasks", column: "dependent_task_id"
  add_foreign_key "taxon_entities", "taxons", on_delete: :cascade
  add_foreign_key "taxonomy_repos", "taxonomies", on_delete: :cascade
  add_foreign_key "taxons", "taxonomies", on_delete: :cascade
end
