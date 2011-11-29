class SessionsController < ApplicationController
	def new
		@title = "Sign in"
	end

	def create
		user=User.authenticate(params[:session][:email], params[:session][:password])
		if user.nil?
			@title="Sign in"
			flash.now[:error]=render_to_string(:partial=>"shared/signin_failure").html_safe;
			render 'new'
		else
			sign_in user
			flash[:success]=render_to_string(:partial=>"shared/signin_success").html_safe;
			redirect_to user;
		end
	end

	def destroy
		sign_out
		redirect_to root_path
	end
end
