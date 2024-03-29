require 'spec_helper'

describe SessionsController do
	render_views

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end

	it "should have the right title" do
		get 'new'
		response.should have_selector("title", :content=>"Sign in")
	end
  end

	describe "DELETE 'destroy'" do
		it "should sign the user out" do
			test_sign_in(Factory(:user))
			delete :destroy
			controller.should_not be_signed_in
			response.should redirect_to(root_path)
		end
	end

	describe "POST 'create'" do
		describe "successful signin" do
			before(:each) do
				@user=Factory(:user)
				@attr={:email=>@user.email, :password=>@user.password}
			end

			it "should sign in the user" do
				post :create, :session=>@attr
				controller.current_user.should==@user
				controller.should be_signed_in
			end
			it "should redirect to the user's profile" do
				post :create, :session=>@attr
				response.should redirect_to(user_path(@user))
			end
			it "should also show a welcome back message" do
				post :create, :session=>@attr
				flash[:success].should =~ /welcome/i
			end
			
		end

		describe "invalid signin" do
			before(:each) do
				@attr={ :email=>"email@example.com", :password=>"invalid" }
			end

			it "should redirect back to the login page" do
				post :create, :session=>@attr
				response.should render_template('new')
			end

			it "should have the correct title" do
				post :create, :session=>@attr
				response.should have_selector(:title, :content=>"Sign in")
			end

			it "should have a flash message" do
				post :create, :session=>@attr
				flash.now[:error].should =~ /invalid/i
			end
		end
	end
end
