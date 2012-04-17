class AddOrderingToImage < ActiveRecord::Migration
  def change
    add_column :images, :ordering, :string, limit: 1
  end
end
