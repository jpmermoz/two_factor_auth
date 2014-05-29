class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.string :phone_number
      t.string :password_digest
      t.string :remember_token
      t.string :confirmation_code
      t.timestamp :sent_at

      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index :users, :phone_number, unique: true
    add_index :users, :remember_token
  end
end
