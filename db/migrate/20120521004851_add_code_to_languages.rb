class AddCodeToLanguages < ActiveRecord::Migration
  def change
    add_column :languages, :code, :string, limit: 10
  end
end
