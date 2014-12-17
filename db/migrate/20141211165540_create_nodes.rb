# Migration
class CreateNodes < ActiveRecord::Migration
  # Migration
  def change
    create_table :nodes do |t|
      t.string :name
      t.string :status
      t.integer :no_of_reports
      t.datetime :last_run
    end
  end
end
