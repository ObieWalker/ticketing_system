class ChangeColumnNameRequestToRequestBody < ActiveRecord::Migration[5.2]
  def change
    rename_column :requests, :request, :request_body
  end
end
