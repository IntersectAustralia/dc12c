class AddingDateToRequests < ActiveRecord::Migration
  def change
    add_column :access_requests, :date_requested, :date
    add_column :access_requests, :date_approved, :date
  end
end
