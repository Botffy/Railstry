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

end
