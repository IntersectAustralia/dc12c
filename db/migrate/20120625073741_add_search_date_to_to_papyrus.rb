class AddSearchDateToToPapyrus < ActiveRecord::Migration
  def change
    add_column :papyri, :search_date_to, :integer
  end
end
