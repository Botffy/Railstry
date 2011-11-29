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

require 'spec_helper'

describe User do

	before(:each) do
		@attr = { :name => "Example User", :email => "user@example.com", :password=>"foobar", :password_confirmation=>"foobar" }
	end

	it "should create a new instance given valid attributes" do
		User.create!(@attr)
	end

	it "should require a name" do
		no_name_user = User.new(@attr.merge(:name => ""))
		no_name_user.should_not be_valid
	end

	it "should reject overlong names" do
		long_name_user = User.new(@attr.merge(:name => "."*51))
		long_name_user.should_not be_valid
  	end

	it "should require an email address" do
		no_email_user = User.new(@attr.merge(:email => ""))
		no_email_user.should_not be_valid
	end

	it "should accept valid email addresses" do
		%w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp].each do |address|
			valid_email_user = User.new(@attr.merge(:email => address))
			valid_email_user.should be_valid
		end
	end

	it "should reject invalid email addresses" do
		addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
		addresses.each do |address|
			invalid_email_user = User.new(@attr.merge(:email => address))
			invalid_email_user.should_not be_valid
		end
	end

	it "should reject duplicate email addresses" do
    		User.create!(@attr)
		user_with_duplicate_email = User.new(@attr)
		user_with_duplicate_email.should_not be_valid
	end

	it "should reject duplicate email adresses case-insensitively" do
		User.create!(@attr.merge(:email => @attr[:email].upcase))
		user_with_duplicate_email = User.new(@attr)
		user_with_duplicate_email.should_not be_valid
  	end


	describe "password validations" do
		it "should require a password" do
			User.new(@attr.merge(:password => "", :password_confirmation => "")).should_not be_valid
		end
		it "should require a matching password confirmation" do
			User.new(@attr.merge(:password_confirmation => "invalid")).
			should_not be_valid
		end

		it "should reject short passwords" do
      		hash = @attr.merge(:password => "a"*5, :password_confirmation =>  "a"*5)
      		User.new(hash).should_not be_valid
		end

		it "should reject overlong passwords" do
      		hash=@attr.merge(:password => "a"*41, :password_confirmation => "a"*41)
      		User.new(hash).should_not be_valid
		end
	end

	describe "password encryption" do
		before(:each) do
			@user = User.create!(@attr)
		end

		it "should have an encrypted password attribute" do
			@user.should respond_to(:encrypted_password)
		end
		it "should set the encrypted password" do
			@user.encrypted_password.should_not be_blank
    		end


		describe "has_password? method" do
			it "should be true if the passwords match" do
        			@user.has_password?(@attr[:password]).should be_true
      		end

      		it "should be false if the passwords don't match" do
				@user.has_password?("invalid").should be_false
			end 
		end

		describe "authenticate method" do
			it "should return nil when there's an email/password mismatch" do
				wrongpass=User.authenticate(@attr[:email], "wrongpass")
				wrongpass.should be_nil
			end
			it "should return nil for unknown email addresses" do
				nosuch=User.authenticate("example@example.com", @attr[:password])
				nosuch.should be_nil
			end
			it "should return the user object if there's a match" do
				match=User.authenticate(@attr[:email], @attr[:password])
				match.should==@user
			end
		end
		
	end

end


