require 'spec_helper'

describe "Users" do

	describe "signup" do
		describe "failure" do
			it "should not make a new user" do
				lambda do
					visit signup_path
					fill_in :user_name, :with => ""
					fill_in :user_email, :with => ""
					fill_in :user_password, :with => ""
					fill_in :user_password_confirmation, :with => ""
					click_button
					response.should render_template('users/new')
					response.should have_selector('div#error_explanation')
				end.should_not change(User, :count)
			end
		end
		describe "success" do
			it "should make a new user" do
				lambda do
					visit signup_path
					fill_in :user_name, :with => "User Try"
					fill_in :user_email, :with => "user_try@example.com"
					fill_in :user_password, :with => "bubububu"
					fill_in :user_password_confirmation, :with => "bubububu"
					click_button
					response.should render_template('users/show')
					response.should have_selector('div.flash', :content=>"Welcome")
				end.should change(User, :count).by(1)
			end
		end
	end


	describe "sign in/sign out" do
		describe "failure" do
			it "should not sign a user in" do
				visit signin_path
				fill_in :email, :with=>""
				fill_in :password, :with=>""
				click_button
				response.should have_selector("div.flash.error", :content=>"Invalid")
			end
		end
		describe "successive successes" do
			it "should sign a user in and out" do
				user=Factory(:user)
				visit signin_path
				fill_in :email, :with=>user.email
				fill_in :password, :with=>user.password
				click_button
				controller.should be_signed_in
				click_link "Sign out"
				controller.should_not be_signed_in
			end
		end
	end

end
