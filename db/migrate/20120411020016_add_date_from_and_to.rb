class AddDateFromAndTo < ActiveRecord::Migration
  def change
    remove_column :papyri, :date_year
    remove_column :papyri, :date_era

    change_table :papyri do |t|
      # These are years
      # e.g. -234 = 234 BCE, 12 = 12 CE
      t.integer :date_from
      t.integer :date_to
    end
  end
end
