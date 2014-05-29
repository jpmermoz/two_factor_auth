class TwilioCredential < ActiveRecord::Base
	validates :sid, :auth_token, :phone_number, presence: true
end