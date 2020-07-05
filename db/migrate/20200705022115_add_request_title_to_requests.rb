class AddRequestTitleToRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :requests, :request_title, :string
  end
end
