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

ActiveRecord::Schema.define(version: 2018_11_09_122210) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "accounts", force: :cascade do |t|
    t.string "login"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "schema_id"
    t.boolean "banned", default: false
    t.string "world", default: "439"
    t.bigint "account_type_id"
    t.string "username"
    t.index ["account_type_id"], name: "index_accounts_on_account_type_id"
    t.index ["schema_id"], name: "index_accounts_on_schema_id"
  end

  create_table "areas", force: :cascade do |t|
    t.string "name"
    t.text "coordinates"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "break_conditions", force: :cascade do |t|
    t.string "name"
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

  create_table "levels", force: :cascade do |t|
    t.string "name"
    t.string "level"
    t.bigint "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_levels_on_account_id"
  end

  create_table "logs", force: :cascade do |t|
    t.string "text"
    t.bigint "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "computer_id"
    t.index ["account_id"], name: "index_logs_on_account_id"
  end

  create_table "mule_withdraw_tasks", force: :cascade do |t|
    t.string "name"
    t.bigint "area_id"
    t.bigint "task_type_id"
    t.string "slave_name"
    t.string "item_id"
    t.string "item_amount"
    t.string "world"
    t.boolean "executed"
    t.bigint "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_mule_withdraw_tasks_on_account_id"
    t.index ["area_id"], name: "index_mule_withdraw_tasks_on_area_id"
    t.index ["task_type_id"], name: "index_mule_withdraw_tasks_on_task_type_id"
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
    t.string "port"
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

  create_table "schemas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
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
    t.bigint "break_condition_id"
    t.integer "break_after"
    t.time "start_time"
    t.time "end_time"
    t.bigint "schema_id"
    t.index ["action_area_id"], name: "index_tasks_on_action_area_id"
    t.index ["axe_id"], name: "index_tasks_on_axe_id"
    t.index ["bank_area_id"], name: "index_tasks_on_bank_area_id"
    t.index ["break_condition_id"], name: "index_tasks_on_break_condition_id"
    t.index ["schema_id"], name: "index_tasks_on_schema_id"
    t.index ["task_type_id"], name: "index_tasks_on_task_type_id"
  end

  create_table "woodcutting_tasks", force: :cascade do |t|
    t.string "treeName"
    t.bigint "axe_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["axe_id"], name: "index_woodcutting_tasks_on_axe_id"
  end

  add_foreign_key "accounts", "account_types"
  add_foreign_key "accounts", "schemas"
  add_foreign_key "instructions", "accounts"
  add_foreign_key "instructions", "instruction_types"
  add_foreign_key "instructions", "scripts"
  add_foreign_key "levels", "accounts"
  add_foreign_key "mule_withdraw_tasks", "accounts"
  add_foreign_key "mule_withdraw_tasks", "areas"
  add_foreign_key "mule_withdraw_tasks", "task_types"
  add_foreign_key "tasks", "break_conditions"
  add_foreign_key "tasks", "schemas"
  add_foreign_key "tasks", "task_types"
end
