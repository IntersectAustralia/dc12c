class CreateCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
      t.string :title, limit: 255
      t.string :description, limit: 512
      t.string :keywords, limit: 255
    end
    create_table :collections_papyri, id: false do |t|
      t.references :collection
      t.references :papyrus
    end
  end
end
