class CreateLogEntries < ActiveRecord::Migration
  def change
    create_table :log_entries do |t|
      t.datetime :time
      t.string :level
      t.string :source
      t.integer :line
      t.text :message

      t.references :report
    end
  end
end
