class RemoveIdFromLanguages < ActiveRecord::Migration
  def change
    drop_table :languages_papyri
    create_table :languages_papyri, id: false do |t|
      t.references :language
      t.references :papyrus
    end
  end
end
