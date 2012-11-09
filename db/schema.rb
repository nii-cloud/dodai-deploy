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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111027025254) do

  create_table "component_config_defaults", :force => true do |t|
    t.string   "path"
    t.text     "content"
    t.integer  "component_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "component_configs", :force => true do |t|
    t.integer  "proposal_id"
    t.integer  "component_id"
    t.integer  "component_config_default_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "component_dependencies", :force => true do |t|
    t.integer  "source_component_id"
    t.integer  "dest_component_id"
    t.integer  "software_id"
    t.string   "operation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "components", :force => true do |t|
    t.string   "name"
    t.integer  "software_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "config_item_defaults", :force => true do |t|
    t.integer  "software_id"
    t.string   "name"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "config_items", :force => true do |t|
    t.integer  "config_item_default_id"
    t.integer  "proposal_id"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "logs", :force => true do |t|
    t.text     "content"
    t.string   "operation"
    t.integer  "proposal_id"
    t.integer  "node_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "node_configs", :force => true do |t|
    t.integer  "proposal_id"
    t.integer  "node_id"
    t.integer  "component_id"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nodes", :force => true do |t|
    t.string   "name"
    t.string   "ip"
    t.string   "state"
    t.string   "os"
    t.string   "os_version"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "proposals", :force => true do |t|
    t.string   "name"
    t.integer  "software_id"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "software_config_defaults", :force => true do |t|
    t.string   "path"
    t.text     "content"
    t.integer  "software_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "software_configs", :force => true do |t|
    t.integer  "software_config_default_id"
    t.integer  "software_id"
    t.integer  "proposal_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "softwares", :force => true do |t|
    t.string   "name"
    t.string   "desc"
    t.string   "os"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "test_components", :force => true do |t|
    t.integer  "software_id"
    t.integer  "component_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "waiting_proposals", :force => true do |t|
    t.integer  "proposal_id"
    t.string   "operation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
