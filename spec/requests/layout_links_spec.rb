require 'spec_helper'

describe "LayoutLinks" do

	before(:each) do
		@base_title="Railstry::"
	end


	it "should have the Home page at root" do
		get '/'
		response.should be_success
		response.should have_selector("title", :content=>@base_title+"Home")
	end

	it "should have the Contact page at '/contact'" do
		get '/contact'
		response.should be_success
		response.should have_selector("title", :content=>@base_title+"Contact")
	end

	it "should have the About page at '/about'" do
		get '/about'
		response.should be_success
		response.should have_selector("title", :content=>@base_title+"About")
	end

	it "should have the Help page at '/help'" do
		get '/help'
		response.should be_success
		response.should have_selector("title", :content=>@base_title+"Help")
	end

	it "should have the Signup page at '/signup'" do
		get '/signup'
		response.should be_success
		response.should have_selector("title", :content=>@base_title+"Signup")
	end

	it "should have the right links leading to the right pages" do
		visit root_path
			click_link "About"
			response.should have_selector('title', :content => "About")

			click_link "Help"
			response.should have_selector('title', :content => "Help")

			click_link "Contact"
			response.should have_selector('title', :content => "Contact")

			#click_link "Home"
			#response.should have_selector('title', :content => "Home")
	end

	describe "when not signed in" do
		it "should have a 'sign in' link that leads to the signin page" do
			visit root_path
			response.should have_selector("a", :href => signin_url, :content => "Sign in")
			click_link "Sign in"
			response.should have_selector('title', :content => "Sign in")
		end
	end

	describe "when signed in" do
		before(:each) do
			@user=Factory(:user)
			integration_sign_in(@user)
		end

		it "should have a signout link" do
			visit root_path
			response.should have_selector("a", :href => signout_url, :content => "Sign out")
		end

		it "should have a profile link" do
			visit root_path
			response.should have_selector("a", :href=>user_path(@user), :content=>"Profile")
		end

		it "should not have signup link on front page" do
			visit root_path
			response.should_not have_selector("a", :href=>signup_path, :content=>"Sign up now!")
		end
	end
	

end
