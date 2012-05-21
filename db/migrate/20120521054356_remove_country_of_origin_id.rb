class RemoveCountryOfOriginId < ActiveRecord::Migration
  def change
    remove_column :papyri, :country_of_origin_id
  end
end
