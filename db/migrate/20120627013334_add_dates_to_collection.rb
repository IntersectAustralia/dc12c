class AddDatesToCollection < ActiveRecord::Migration
  def change
    change_table :collections do |t|
      t.timestamps
    end

  end
end
