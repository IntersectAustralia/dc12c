class ContentFields < ActiveRecord::Migration
  def change
    remove_column :papyri, :recto_note
    remove_column :papyri, :verso_note

    change_table :papyri do |t|
      t.string :recto_verso_note, limit: 511
      t.string :type_of_text, limit: 255
      t.string :modern_textual_dates, limit: 511
      t.string :publications, limit: 127
    end
  end
end
