class AddVolumeItemNumbers < ActiveRecord::Migration
  def change
    add_column :papyri, :volume_number, :string, limit: 4
    add_column :papyri, :item_number, :integer
  end
end
