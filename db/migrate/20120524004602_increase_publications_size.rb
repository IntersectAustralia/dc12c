class IncreasePublicationsSize < ActiveRecord::Migration
  def up
    change_column :papyri, :publications, :string, limit: 255
    change_column :papyri, :mqt_note, :string, limit: 2048
    change_column :papyri, :summary, :string, limit: 1024
    change_column :papyri, :inventory_number, :string, limit: 64
    change_column :papyri, :general_note, :string, limit: 512
  end
end
