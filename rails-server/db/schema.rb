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

ActiveRecord::Schema[7.0].define(version: 2025_04_11_024322) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "chapters", force: :cascade do |t|
    t.bigint "mission_id", null: false
    t.string "title"
    t.text "content"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "short_description", default: "This is short description about this chapter"
    t.index ["mission_id"], name: "index_chapters_on_mission_id"
  end

  create_table "jobs", force: :cascade do |t|
    t.integer "nodes"
    t.integer "walltime"
    t.integer "cores"
    t.string "mail_type"
    t.string "mail_user"
    t.string "state", default: "NA"
    t.string "job_reason_code", default: "None"
    t.text "script"
    t.text "out"
    t.text "err"
    t.bigint "machine_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "project_id"
    t.string "name"
    t.string "out_file"
    t.string "err_file"
    t.integer "slurm_cores", default: 8
    t.index ["machine_id"], name: "index_jobs_on_machine_id"
    t.index ["user_id"], name: "index_jobs_on_user_id"
  end

  create_table "machines", force: :cascade do |t|
    t.string "name"
    t.decimal "storage", precision: 12, scale: 2
    t.integer "cores"
    t.integer "cpus"
    t.integer "nodes"
    t.integer "gpus"
    t.json "modules_list"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "user_id"], name: "index_machines_on_name_and_user_id", unique: true
    t.index ["user_id"], name: "index_machines_on_user_id"
  end

  create_table "missions", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.integer "difficulty_level"
    t.boolean "is_completed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_projects_on_name", unique: true
  end

  create_table "quizzes", force: :cascade do |t|
    t.bigint "chapter_id", null: false
    t.text "question"
    t.string "question_type"
    t.jsonb "options"
    t.integer "correct_option_index"
    t.text "explanation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chapter_id"], name: "index_quizzes_on_chapter_id"
  end

  create_table "user_chapters", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "chapter_id", null: false
    t.boolean "completed"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chapter_id"], name: "index_user_chapters_on_chapter_id"
    t.index ["user_id"], name: "index_user_chapters_on_user_id"
  end

  create_table "user_missions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "mission_id", null: false
    t.boolean "completed"
    t.datetime "started_at"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mission_id"], name: "index_user_missions_on_mission_id"
    t.index ["user_id"], name: "index_user_missions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "username"
    t.string "email"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "chapters", "missions"
  add_foreign_key "jobs", "machines"
  add_foreign_key "jobs", "projects"
  add_foreign_key "jobs", "users"
  add_foreign_key "machines", "users"
  add_foreign_key "quizzes", "chapters"
  add_foreign_key "user_chapters", "chapters"
  add_foreign_key "user_chapters", "users"
  add_foreign_key "user_missions", "missions"
  add_foreign_key "user_missions", "users"
end
