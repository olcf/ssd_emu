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

ActiveRecord::Schema[7.0].define(version: 2024_11_01_192856) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "jobs", force: :cascade do |t|
    t.string "project_name"
    t.integer "nodes"
    t.integer "walltime"
    t.integer "cores"
    t.string "mail_type"
    t.string "mail_user"
    t.string "state"
    t.string "job_reason_code"
    t.text "script"
    t.text "output"
    t.text "errors"
    t.bigint "machine_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  add_foreign_key "jobs", "machines"
  add_foreign_key "jobs", "users"
  add_foreign_key "machines", "users"
end
