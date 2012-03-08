class CreatePapyri < ActiveRecord::Migration
  def change
    create_table :papyri do |t|

      t.string :inventory_id
      t.integer :width
      t.integer :height
      t.string :general_note
      t.string :note
      t.string :paleographic_description
      t.string :recto_note
      t.string :verso_note
      t.string :origin_details
      t.string :source_of_acquisition
      t.string :preservation_note
      t.string :language_note
      t.string :summary
      t.string :original_text
      t.string :translated_text

    end
  end
end
