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

	describe "validations" do
		it "should require an associated user" do
			Micropost.new(@attr).should_not be_valid
		end
		it "should require some content" do
			@user.microposts.build(:content=>"").should_not be_valid
		end
		it "should reject overlong content" do
			@user.microposts.build(:content=>'a'*301).should_not be_valid
		end
	end
end
