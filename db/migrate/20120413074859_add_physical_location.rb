class AddPhysicalLocation < ActiveRecord::Migration
  def change
     add_column :papyri, :physical_location, :string, limit: 255, null: true
  end
end
