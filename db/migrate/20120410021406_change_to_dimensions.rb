class ChangeToDimensions < ActiveRecord::Migration
  def change
    remove_column :papyri, :width    
    remove_column :papyri, :height    
    add_column :papyri, :dimensions, :string, limit: 511, null: true
  end

end
