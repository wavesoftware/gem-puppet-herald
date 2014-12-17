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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_141_211_171_326) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'log_entries', force: true do |t|
    t.datetime 'time'
    t.string 'level'
    t.string 'source'
    t.integer 'line'
    t.text 'message'
    t.integer 'report_id'
  end

  create_table 'nodes', force: true do |t|
    t.string 'name'
    t.string 'status'
    t.integer 'no_of_reports'
    t.datetime 'last_run'
  end

  create_table 'reports', force: true do |t|
    t.string 'status'
    t.string 'environment'
    t.string 'transaction_uuid'
    t.string 'configuration_version'
    t.string 'puppet_version'
    t.string 'kind'
    t.string 'host'
    t.datetime 'time'
    t.integer 'node_id'
  end
end
