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

		it "should have a name field" do
			get 'new'
			response.should have_selector("input[name='user[name]'][type='text']")			
		end 
		it "should have an email field" do
			get 'new'
			response.should have_selector("input[name='user[email]'][type='text']")			
		end 
		it "should have a password field" do
			get 'new'
			response.should have_selector("input[name='user[password]'][type='password']")			
		end 
		it "should have a password confirmation field" do
			get 'new'
			response.should have_selector("input[name='user[password_confirmation]'][type='password']")			
		end 
	end


	describe "GET 'edit'" do
		before(:each) do
			@user=Factory(:user)
			test_sign_in(@user)
		end

		it "should be successful" do
			get :edit, :id=>@user
			response.should be_success
		end

		it "should have the right title" do
			get :edit, :id=>@user
			response.should have_selector("title",:content=>"Edit")
		end

		it "should have a link to change Gravatar" do
			get :edit, :id=>@user
			response.should have_selector("a", :href=>"http://gravatar.com/emails", :content=>"change")
		end
	end



	describe "PUT 'update'" do
		before(:each) do
			@user=Factory(:user)
			test_sign_in(@user)
		end

		describe "failure" do
			before(:each) do
				@attr={ :email=>"", :name=>"", :password=>"", :password_confirmation=>"" }
			end

			it "should render the edit page again" do
				put :update, :id=>@user, :user=>@attr
				response.should render_template('edit')
			end

			it "should have the right title" do
				put :update, :id=>@user, :user=>@attr
				response.should have_selector("title", :content=>"Edit")
			end
		end
		
		describe "success" do
			before(:each) do
				@attr={ :name=>"Muk Muk", :email=>"mukmuk@muk.muk", :password =>"mukmuk", :password_confirmation => "mukmuk" }
			end

			it "should change the user's attributes" do
				put :update, :id=>@user, :user=>@attr
				@user.reload
				@user.name.should == @attr[:name]
				@user.email.should == @attr[:email]
			end

			it "should redirect to the users profile" do
				put :update, :id=>@user, :user=>@attr
				response.should redirect_to(user_path(@user))
			end

			it "should have a flash notification" do
				put :update, :id=>@user, :user=>@attr
				flash[:success].should=~/updated/
			end
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

			it "should sign the user in" do
				post :create, :user=>@attr
				controller.should be_signed_in
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
