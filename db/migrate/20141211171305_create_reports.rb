class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string      :status
      t.string      :environment
      t.string      :transaction_uuid
      t.string      :configuration_version
      t.string      :puppet_version
      t.string      :kind
      t.string      :host
      t.datetime    :time
      
      t.references  :node
    end
  end
end
