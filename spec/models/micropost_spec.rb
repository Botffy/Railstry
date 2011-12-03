require 'spec_helper'

describe Micropost do
	before(:each) do
		@user=Factory(:user)
		@attr={:content => "lorem ipsum"}
	end

	it "should create a new instance from valid attributes" do
		@user.microposts.create!(@attr)
	end

	describe "association with users" do
		before(:each) do
			@post=@user.microposts.create!(@attr)
		end

		it "should have a user attribute" do
			@post.should respond_to(:user)
		end
		it "should be associated with the right user" do
			@post.user_id.should == @user.id
			@post.user.should == @user
		end
	end
end
