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

ActiveRecord::Schema.define(version: 2018_10_24_101140) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "login"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "areas", force: :cascade do |t|
    t.string "name"
    t.text "coordinates"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "computers", force: :cascade do |t|
    t.string "ip"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_computers_on_name", unique: true
  end

  create_table "instruction_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "instructions", force: :cascade do |t|
    t.bigint "instruction_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "computer_id"
    t.boolean "completed", default: false
    t.bigint "account_id"
    t.bigint "script_id"
    t.index ["account_id"], name: "index_instructions_on_account_id"
    t.index ["computer_id"], name: "index_instructions_on_computer_id"
    t.index ["instruction_type_id"], name: "index_instructions_on_instruction_type_id"
    t.index ["script_id"], name: "index_instructions_on_script_id"
  end

  create_table "logs", force: :cascade do |t|
    t.string "text"
    t.bigint "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "computer_id"
    t.index ["account_id"], name: "index_logs_on_account_id"
  end

  create_table "npcs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "proxies", force: :cascade do |t|
    t.bigint "account_id"
    t.string "location"
    t.string "ip"
    t.string "username"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_proxies_on_account_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.integer "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["number"], name: "index_rooms_on_number", unique: true
  end

  create_table "rs_items", force: :cascade do |t|
    t.integer "itemId"
    t.string "itemName"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "scripts", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "task_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.string "name"
    t.bigint "bank_area_id"
    t.bigint "action_area_id"
    t.bigint "task_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "axe_id"
    t.string "treeName"
    t.index ["action_area_id"], name: "index_tasks_on_action_area_id"
    t.index ["axe_id"], name: "index_tasks_on_axe_id"
    t.index ["bank_area_id"], name: "index_tasks_on_bank_area_id"
    t.index ["task_type_id"], name: "index_tasks_on_task_type_id"
  end

  create_table "woodcutting_tasks", force: :cascade do |t|
    t.string "treeName"
    t.bigint "axe_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["axe_id"], name: "index_woodcutting_tasks_on_axe_id"
  end

  add_foreign_key "instructions", "accounts"
  add_foreign_key "instructions", "instruction_types"
  add_foreign_key "instructions", "scripts"
  add_foreign_key "tasks", "task_types"
end
