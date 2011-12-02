class UsersController < ApplicationController
	before_filter :unregistered_users_only, :only=>[:new, :create]
	before_filter :authenticate, :only=>[:edit, :update, :index, :destroy]
	before_filter :correct_user, :only=>[:edit, :update]
	before_filter :admin_user, :only=>:destroy


	def index
		@title="Users"
		@users=User.paginate(:page=>params[:page])
	end

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

	def destroy
		if User.find(params[:id]) == current_user
			flash[:failure]="You can't delete yourself, dummy."
			redirect_to users_path
		else
			User.find(params[:id]).destroy
			flash[:success]="The user has been struck down."
			redirect_to users_path
		end
	end


		private


	def unregistered_users_only
		redirect_to(root_path) if signed_in?
	end

	def authenticate
		deny_access unless signed_in?
	end

	def correct_user
		@user=User.find(params[:id])
		redirect_to(root_path) unless current_user?(@user)
	end

	def admin_user
		redirect_to(root_path) unless current_user.admin?
	end
end
