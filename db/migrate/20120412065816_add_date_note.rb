class AddDateNote < ActiveRecord::Migration
  def change
    add_column :papyri, :date_note, :string, max_length: 511
  end
end
