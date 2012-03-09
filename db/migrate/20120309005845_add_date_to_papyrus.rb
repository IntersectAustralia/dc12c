class AddDateToPapyrus < ActiveRecord::Migration
  def change
    change_table :papyri do |t|
      t.integer :date_year
      t.string :date_era
    end
  end
end
