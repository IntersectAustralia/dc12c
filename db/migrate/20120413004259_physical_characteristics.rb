class PhysicalCharacteristics < ActiveRecord::Migration
  def change
    change_table :papyri do |t|
      t.string :material, limit: 255
      t.change :preservation_note, :string, limit: 1023
      t.string :conservation_note, limit: 1023
      t.change :paleographic_description, :string, limit: 1023
      t.string :other_characteristics, limit: 1023

      t.rename :note, :lines_of_text
      t.change :lines_of_text, :string, limit: 1023

    end
  end
end
