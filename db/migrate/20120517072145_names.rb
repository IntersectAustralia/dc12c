class Names < ActiveRecord::Migration
  def change
    create_table :names do |t|
      t.references :papyrus, null: false
      t.string :name, limit: 64, null: false
      t.string :role, limit: 32
      t.string :role_note, limit: 127
      t.string :added_information, limit: 255
      t.string :date, limit: 255
      t.string :ordering, limit: 1
    end
  end
end
