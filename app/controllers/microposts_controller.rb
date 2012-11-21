class MicropostsController < ApplicationController
	before_filter :signed_in_user, :only => [:create, :destroy]
	before_filter :correct_user, :only => [:destroy]

	def create
		@msg = "Micropost created!"
		@micropost = current_user.microposts.build(params[:micropost])
		if @micropost[:content][0, 3] == 'p ~'
			@micropost.toggle!(:priv)
			@micropost.from = @micropost.user
			@micropost.user = User.find(:first, :conditions => { :username => @micropost.content[3, @micropost.content.index(/\s/, 3) - 3] })
			@micropost.content = @micropost.content[@micropost.content.index(/\s/, 3), @micropost.content.length]
			if @micropost.content.length <= 500
				@msg = "Private post sent!"
			else
				@msg = "Private post maximum length exceded (500 character length)"
			end
		else
			@micropost.from = 0
			if @micropost.content.length > 140
				@msg = "Micropost maximum length exceded (140 character length)"
			end
		end

		@micropost.content.insert @micropost.content.length, " "

		if @micropost.save
			if (@micropost.from == 0 || User.find(@micropost.from) != User.find(@micropost.user))
				if (@micropost.priv? && @micropost.content.length <= 500) || (!@micropost.priv? && @micropost.content.length <= 140)
					flash[:success] = @msg
					redirect_to root_path
				else
					flash[:failure] = @msg
				end
			else
				flash[:failure] = "Post failed!"
			end
		else
			@feed_items = []
			render 'static_pages/home'
		end

		if (@micropost.priv? && @micropost.content.length > 500) || (!@micropost.priv? && @micropost.content.length > 140)
			destroy
		end

		if (@micropost.from != 0 && User.find(@micropost.from) == User.find(@micropost.user))
			destroy
		end
	end

	def destroy
		@micropost.destroy
		redirect_back_or root_path
	end

	private
		def correct_user
			@micropost = current_user.microposts.find_by_id(params[:id])
			redirect_to root_path if @micropost.nil?
		end
end