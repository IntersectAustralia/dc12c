class AddCoverageToCollection < ActiveRecord::Migration
  def change
    change_table :collections do |t|
      t.string :spatial_coverage
      t.string :temporal_coverage
    end
  end
end
