class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :caption, limit: 255
      t.references :papyrus
      t.has_attached_file :image
    end
  end
end
