class CreateRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :requests do |t|
      t.belongs_to :user
      t.text :request
      t.integer :status
      t.datetime :closed_date
      t.integer :agent_assigned

      t.timestamps
    end


  end
end
