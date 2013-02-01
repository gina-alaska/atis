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

ActiveRecord::Schema.define(:version => 20130201012816) do

  create_table "activities", :force => true do |t|
    t.integer  "subject_id"
    t.string   "subject_type"
    t.integer  "changed_item_id"
    t.string   "changed_item_type"
    t.string   "verb"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "owner_id"
  end

  create_table "attachments", :force => true do |t|
    t.string   "name"
    t.string   "file_uid"
    t.integer  "parent_id"
    t.string   "parent_type"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "awards", :force => true do |t|
    t.string   "slug"
    t.string   "title"
    t.text     "description"
    t.integer  "group_id"
    t.integer  "pi_id"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.string   "state"
    t.integer  "mau_id"
    t.string   "institute"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.decimal  "budget",      :precision => 12, :scale => 2
    t.string   "account"
  end

  create_table "disciplines", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "disciplines_sows", :id => false, :force => true do |t|
    t.integer "sow_id"
    t.integer "discipline_id"
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.string   "acronym"
    t.integer  "fiscal_coordinator_id"
    t.integer  "director_id"
    t.integer  "parent_id"
    t.integer  "top_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  create_table "maus", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  create_table "services", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "uname"
    t.string   "uemail"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sows", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "telephone"
    t.string   "ua_number"
    t.string   "period"
    t.string   "project_title"
    t.string   "other_strategic_objective"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.text     "statement_of_work"
    t.text     "collaborators"
    t.text     "research_milestones_and_outcomes"
    t.text     "accomplished_objectives"
    t.text     "budget_justification"
    t.string   "research_period_of_performance"
    t.integer  "other_period"
    t.integer  "owner_id"
    t.string   "state"
    t.integer  "created_by"
    t.datetime "submitted_on"
    t.integer  "submitted_by_id"
    t.integer  "reviewed_by_id"
    t.datetime "accepted_on"
    t.datetime "rejected_on"
    t.boolean  "climate_glacier_dynamics"
    t.boolean  "ecosystem_variability"
    t.boolean  "resource_management"
    t.boolean  "other_strategic_objectives"
    t.string   "other_strategic_objectives_text"
    t.integer  "award_group_id"
    t.integer  "pi_approval_id"
    t.integer  "group_leader_approval_id"
    t.text     "review_notes"
    t.integer  "award_id"
    t.integer  "mau_id"
    t.string   "institute"
    t.datetime "starts_at"
    t.datetime "ends_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "active_dashboard", :default => "submitter"
  end

end
