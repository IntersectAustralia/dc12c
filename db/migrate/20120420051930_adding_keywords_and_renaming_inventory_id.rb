class AddingKeywordsAndRenamingInventoryId < ActiveRecord::Migration
  def change
    add_column :papyri, :keywords, :string
    rename_column :papyri, :inventory_id, :inventory_number
  end

end
