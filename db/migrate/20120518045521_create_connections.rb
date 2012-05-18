class CreateConnections < ActiveRecord::Migration
  def change
    create_table :connections do |t|
      t.references :papyrus, null: false
      t.integer :related_papyrus_id, null: false
      t.string :description, null: false, limit: 255
    end
  end
end
