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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130128225851) do

  create_table "clients", :force => true do |t|
    t.integer  "harvest_id"
    t.string   "name"
    t.integer  "highrise_id"
    t.integer  "cache_version"
    t.string   "currency"
    t.boolean  "active"
    t.text     "details"
    t.string   "default_invoice_timeframe"
    t.string   "last_invoice_kind"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "clients", ["harvest_id"], :name => "index_clients_on_harvest_id"
  add_index "clients", ["highrise_id"], :name => "index_clients_on_highrise_id"

  create_table "invoices", :force => true do |t|
    t.text     "subject"
    t.string   "number"
    t.date     "issued_at"
    t.date     "due_at"
    t.string   "due_at_human_format"
    t.decimal  "due_amount",           :precision => 10, :scale => 2
    t.text     "notes"
    t.integer  "recurring_invoice_id"
    t.date     "period_start"
    t.date     "period_end"
    t.decimal  "discount",             :precision => 10, :scale => 2
    t.decimal  "discount_amount",      :precision => 10, :scale => 2
    t.string   "client_key"
    t.decimal  "amount",               :precision => 10, :scale => 2
    t.decimal  "tax",                  :precision => 10, :scale => 2
    t.decimal  "tax2",                 :precision => 10, :scale => 2
    t.decimal  "tax_amount",           :precision => 10, :scale => 2
    t.decimal  "tax2_amount",          :precision => 10, :scale => 2
    t.integer  "estimate_id"
    t.string   "purchase_order"
    t.integer  "retainer_id"
    t.string   "currency"
    t.string   "state"
    t.integer  "harvest_id"
    t.integer  "user_id"
    t.integer  "client_id"
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
  end

  add_index "invoices", ["estimate_id"], :name => "index_invoices_on_estimate_id"
  add_index "invoices", ["harvest_id"], :name => "index_invoices_on_harvest_id"
  add_index "invoices", ["recurring_invoice_id"], :name => "index_invoices_on_recurring_invoice_id"
  add_index "invoices", ["retainer_id"], :name => "index_invoices_on_retainer_id"

  create_table "line_items", :force => true do |t|
    t.string   "kind"
    t.text     "description"
    t.decimal  "quantity",    :precision => 10, :scale => 2
    t.decimal  "unit_price",  :precision => 10, :scale => 2
    t.decimal  "amount",      :precision => 10, :scale => 2
    t.boolean  "taxed"
    t.boolean  "taxed2"
    t.integer  "project_id"
    t.integer  "invoice_id"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  add_index "line_items", ["project_id"], :name => "index_line_items_on_project_id"

  create_table "users", :force => true do |t|
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "access_token"
    t.string   "refresh_token"
    t.string   "email"
    t.string   "provider"
    t.integer  "token_expires_at"
    t.boolean  "token_expires"
    t.string   "subdomain"
  end

end
