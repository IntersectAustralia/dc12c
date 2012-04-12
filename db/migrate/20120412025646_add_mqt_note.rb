class AddMqtNote < ActiveRecord::Migration
  def change
    add_column :papyri, :mqt_note, :string, limit: 255, null: true
  end
end
