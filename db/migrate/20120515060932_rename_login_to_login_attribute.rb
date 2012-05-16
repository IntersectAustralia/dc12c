class RenameLoginToLoginAttribute < ActiveRecord::Migration
  def change
    rename_column :users, :login, :login_attribute
  end
end
