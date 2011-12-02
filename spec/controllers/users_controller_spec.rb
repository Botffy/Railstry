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


	describe "authentication of edit/update" do
		before(:each) do
			@user=Factory(:user)
		end

		describe "for visitors" do
			it "should deny access to the edit page" do
				get :edit, :id=>@user
				response.should redirect_to(signin_path)
			end
			it "should deny access to the update action" do
				put :update, :id=>@user, :user=>{}
				response.should redirect_to(signin_path)
			end
		end

		describe "for other users" do
			before(:each) do
				wrong_user=Factory(:user, :email=>"other@user.us")
				test_sign_in(wrong_user)
			end

			it "should require that a user can access only his own edit page" do
				get :edit, :id=>@user
				response.should redirect_to(root_path)
			end
			it "should require that a user can only update his own data" do
				put :update, :id=>@user, :user=>{}
				response.should redirect_to(root_path)
			end
		end
	end


	describe "DELETE 'destroy'" do
		before(:each) do
			@user=Factory(:user)
		end

		describe "as a visitor" do
			it "should deny the request" do
				delete :destroy, :id=>@user
				response.should redirect_to(signin_path)
			end
		end

		describe "as a user who's not an admin" do
			it "should protect the page" do
				test_sign_in(@user)
				delete :destroy, :id=>@user
				response.should redirect_to(root_path)
			end
		end

		describe "as an admin" do
			before(:each) do
				@admin=Factory(:user, :email=>"admin@example.com", :admin=>true)
				test_sign_in(@admin)
			end

			it "should destroy the user" do
				lambda do
					delete :destroy, :id=>@user
				end.should change(User, :count).by(-1)
			end

			it "should redirect to the userindex" do
				delete :destroy, :id=>@user
				response.should redirect_to(users_path)
			end

			it "should not destroy himself" do
				lambda do
					delete :destroy, :id=>@admin
				end.should_not change(User, :count)
			end
		end
	end


	describe "GET 'index'" do
		describe "for visitors" do
			it "should deny access" do
				get :index
				response.should redirect_to(signin_path)
				flash[:notice].should=~/signed in/i
			end
		end
		describe "for signed-in users" do
			before(:each) do
				@user=test_sign_in(Factory(:user))

				@users=[@user, Factory(:user, :name=>"Mormota", :email=>"mormota@mormo.ta"), Factory(:user, :name=>"Cica", :email=>"cica@ci.ca")]

				30.times do
					@users << Factory(:user, :name=>Factory.next(:name), :email=>Factory.next(:email))
				end
			end

			it "should be successful" do
				get :index
				response.should be_success
			end
			it "should have the right title" do
				get :index
				response.should have_selector("title", :content=>"Users")
			end

			it "should have entries for the existing users" do
				get :index
				@users[0..2].each do |user|
					response.should have_selector("li", :content=>user.name)
				end
			end

			it "should paginate the user page" do
				get :index
				response.should have_selector("div.pagination")
				response.should have_selector("span.disabled", :content=>"Previous")
				response.should have_selector("a", :content=>"2")
				response.should have_selector("a", :content=>"Next") #:href=>"/users?escape=false&amp;page=2", 
			end
		end
	end
end
