class FixFieldLengths < ActiveRecord::Migration
  def up
    change_column :papyri, :original_text, :string, limit: 4000
    change_column :papyri, :translated_text, :string, limit: 4000
    change_column :papyri, :date_note, :string, limit: 511
    change_column :papyri, :publications, :string, limit: 511
  end
end
