class EncryptedPasswordIsNullable < ActiveRecord::Migration
  def change
    change_column :users, :encrypted_password, :string, default: nil, null: true
  end
end
