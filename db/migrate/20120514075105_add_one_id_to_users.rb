class AddOneIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :one_id, :string, limit: 10
  end
end
