class CreateRequestAccess < ActiveRecord::Migration
  def change
    create_table :access_requests do |t|
      t.references :user
      t.references :papyrus
      t.string :status
    end
  end

end
