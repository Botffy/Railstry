class UsersController < ApplicationController
	before_filter :authenticate, :only=>[:edit, :update]

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

	def update
		@user=User.find(params[:id])
		if @user.update_attributes(params[:user])
			flash[:success]=render_to_string(:partial=>"shared/edit_profile_success").html_safe;
			redirect_to @user
		else
			@title="Edit user"
			render 'edit'
		end
	end


	private

	def authenticate
		deny_access unless signed_in?
	end
end
