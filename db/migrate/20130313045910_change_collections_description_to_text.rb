class ChangeCollectionsDescriptionToText < ActiveRecord::Migration
  def up
    add_column :collections, :description_copy, :clob
    execute "UPDATE collections set description_copy = description"
    remove_column :collections, :description
    rename_column :collections, :description_copy, :description
  end

  def down
    change_table :collections do |t|
      add_column :collections, :description_copy, :string, limit: 512
      execute "UPDATE collections set description_copy = SUBSTR(description, 0, 512)"
      remove_column :collections, :description
      rename_column :collections, :description_copy, :description
    end
  end
end
