class MicropostsController < ApplicationController
	before_filter :authenticate, :only=>[:create, :destroy]

	def create
		@micropost=current_user.microposts.build(params[:micropost])
		if @micropost.save
			flash[:success]="Micropost posted!"
			redirect_to root_path
		else
			render 'pages/home'
		end
	end

	def destroy
	end
end
