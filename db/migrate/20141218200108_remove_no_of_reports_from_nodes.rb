# Migration
class RemoveNoOfReportsFromNodes < ActiveRecord::Migration
  # Migration
  def change
    remove_column :nodes, :no_of_reports, :integer
  end
end
