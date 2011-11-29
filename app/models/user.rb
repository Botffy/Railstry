# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
	attr_accessor :password

	attr_accessible :name, :email, :password, :password_confirmation

	validates :name, 	:presence => true,
					:length => {:maximum => 50}

	validates :email, 	:presence => true,
					:format => {:with => /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i},
					:uniqueness => { :case_sensitive => false }

	validates :password,	:presence=>true,
						:confirmation=>true,
						:length=>{:within => 6..40 }

	before_save :encrypt_password

	#true if the hash of the submitted password equals the hash of the stored password.
	def has_password?(submitted_password)
		self.encrypt_password==encrypt(submitted_password)
	end


	class << self
		def authenticate(email, submitted_password)
			user=User.find_by_email(email)
			return nil if user.nil?
			return user if user.has_password?(submitted_password)
		end
	end


	private

	def encrypt_password
		self.salt = make_salt unless has_password?(password)
		encrypted_password = encrypt(self.password)
	end
	def encrypt(string)
		secure_hash("#{self.salt}--#{string}")
	end
	def make_salt
		secure_hash("#{Time.now.utc}--#{self.password}")
	end
	def secure_hash(string)
		Digest::SHA2.hexdigest(string)
	end

end
