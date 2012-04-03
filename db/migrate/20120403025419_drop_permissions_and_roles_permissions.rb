class DropPermissionsAndRolesPermissions < ActiveRecord::Migration
  def change
    drop_table :permissions
    drop_table :roles_permissions
  end

end
