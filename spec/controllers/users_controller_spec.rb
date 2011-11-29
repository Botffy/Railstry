require 'spec_helper'

describe UsersController do
	render_views

	describe "GET 'new'" do
		it "should be successful" do
			get 'new'
			response.should be_success
		end

		it "should have the right title" do
			get 'new'
			response.should have_selector("title", :content => "Signup")
		end
	end

	describe "POST 'create'" do
		describe 'failure' do
			before(:each) do
				@attr={:name=>"", :email=>"", :password=>"", :password_confirmation=>""}
			end
			it "should not create a user" do
				lambda do
					post :create, :user=>@attr
				end.should_not change(User, :count)
			end
			it "should have the right title" do
				post :create, :user=>@attr
				response.should have_selector("title", :content=>"Signup")
			end
			it "should render the new page" do
				post :create, :user=>@attr
				response.should render_template('new')
			end
		end

		describe 'success' do
			before(:each) do
				@attr={:name=>"Bubu", :email => "bubu@bubu.bub", :password=>"bubububu", :password_confirmation=>"bubububu"}
			end

			it "should create a user" do
				lambda do
					post :create, :user=>@attr
				end.should change(User, :count).by(1)
			end

			it "should redirect to the user's profile on success" do
				post :create, :user=>@attr
				response.should redirect_to(user_path(assigns(:user)))
			end

			it "should have a welcome message flash" do
				post :create, :user=>@attr
				flash[:success].should =~ /welcome/i
			end
		end
	end

	


	describe "GET 'show'" do

		before(:each) do
			@user = Factory(:user)
		end
		it "should be successful" do
			get :show, :id => @user
			response.should be_success
		end
		it "should find the correct user" do
			get :show, :id => @user
			assigns(:user).should == @user
		end
		it "should have the right title" do
			get :show, :id => @user
			response.should have_selector("title",:content=>@user.name)
		end
		it "should include the user's name in a h1" do
      		get :show, :id => @user
      		response.should have_selector("h1",:content=>@user.name)
    		end
		it "should have a profile image around the name" do
			get :show, :id => @user
			response.should have_selector("h1>img", :class=>"gravatar")
		end
	end

end
