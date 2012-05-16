class DeviseLdapFields < ActiveRecord::Migration
  def change
    add_column :users, :is_ldap, :string, default: false, null: false
    add_column :users, :login, :string
    add_column :users, :dn, :string
  end
end
