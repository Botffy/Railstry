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
		@attr = { :name => "Example User", :email => "user@example.com" }
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

end
