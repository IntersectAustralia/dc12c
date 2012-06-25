class IncreaseKeywords511 < ActiveRecord::Migration
  def change
    change_column :papyri, :keywords, :string, limit: 511
  end
end
