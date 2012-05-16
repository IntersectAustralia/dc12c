class IsLdapIsBooleanNotString < ActiveRecord::Migration
  def up
    remove_column :users, :is_ldap
    add_column :users, :is_ldap, :boolean
  end
end
