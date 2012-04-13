class AddApisAndTrismegistosIds < ActiveRecord::Migration
  def change
    add_column :papyri, :apis_id, :string, limit: 32, null: true
    add_column :papyri, :trismegistos_id, :decimal, null: true
  end
end
