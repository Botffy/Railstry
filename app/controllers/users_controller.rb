class UsersController < ApplicationController

	def new
		@title = "Signup"
		@user=User.new
	end

	def create
		@user=User.new(params[:user])
		if @user.save
			sign_in @user
			flash[:success]=render_to_string(:partial=>"shared/signup_success").html_safe;
			redirect_to @user
		else
			@title="Signup"
			render 'new'
		end
	end

	def show
		@user=User.find(params[:id])
		@title=@user.name
	end

	def edit
		@user=User.find(params[:id])
		@title="Edit user"
	end
end
