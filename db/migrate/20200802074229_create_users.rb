class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email_id
      t.string :username, null: false
      t.string :full_name, null: false
      t.boolean :verified, default: false
      t.string :phone_number
      t.string :password_salt
      t.string :hashed_password
      t.timestamps
    end
  end
end
