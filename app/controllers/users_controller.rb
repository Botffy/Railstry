class UsersController < ApplicationController

	def new
		@title = "Signup"
		@user=User.new
	end

	def create
		@user=User.new(params[:user])
		if @user.save
			#success
		else
			@title="Signup"
			render 'new'
		end
	end

	def show
		@user=User.find(params[:id])
		@title=@user.name
	end

end
