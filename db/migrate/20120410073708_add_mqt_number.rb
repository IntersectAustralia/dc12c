class AddMqtNumber < ActiveRecord::Migration
  def change
    add_column :papyri, :mqt_number, :integer, null: false
  end
end
