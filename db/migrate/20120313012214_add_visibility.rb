class AddVisibility < ActiveRecord::Migration
  def change
    add_column :papyri, :visibility, :string, default: Papyrus::HIDDEN
  end

end
