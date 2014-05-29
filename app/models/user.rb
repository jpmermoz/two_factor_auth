require 'twilio-ruby'

class User < ActiveRecord::Base
	has_secure_password

	validates :name, :email, :password_confirmation, :phone_number, presence: true
	validates :password, length: { minimum: 6 }

	validates :phone_number, length: { is: 10 }, uniqueness: true
	validate  :phone_number_is_from_mendoza

	before_save {
		self.email = email.downcase
	}

	after_create {
		self.update_attribute(:phone_number, "+54#{self.phone_number}")
	}

	def self.build_confirmation_code
		SecureRandom.hex[0,6]
	end

	def self.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def self.digest(token)
    Digest::SHA256.hexdigest(token.to_s)
  end

  def send_confirmation_code(code)
  	twilio_credentials = TwilioCredential.first

  	return nil if twilio_credentials.nil?

  	client = Twilio::REST::Client.new(twilio_credentials.sid, twilio_credentials.auth_token)
  	client.account.messages.create(
  		from: twilio_credentials.phone_number,
  		to: self.phone_number,
  		body: "Su código es #{code}"
		)
  end

	private

	def phone_number_is_from_mendoza
		self.errors.add(:phone_number, "debe ser de Mendoza") if phone_number[0,3] != "261"
	end
	
end
