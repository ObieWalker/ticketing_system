class CreateUserAuthentications < ActiveRecord::Migration[5.2]
  def change
    create_table :user_authentications do |t|
      t.belongs_to :user
      t.string :email
      t.string :password_digest
      t.string :token
      t.datetime :token_expire_date

      t.timestamps
    end
  end
end
