class CreateTwilioCredentials < ActiveRecord::Migration
  def change
    create_table :twilio_credentials do |t|
      t.string :sid
      t.string :auth_token
      t.string :phone_number

      t.timestamps
    end

    add_index :twilio_credentials, :phone_number, unique: true
  end
end
