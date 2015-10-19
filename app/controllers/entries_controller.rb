class EntriesController < ApplicationController

	before_action :logged_in_user, only: [:create, :destroy]
	before_action :correct_user, only: [:destroy]

	def create
		@entry = current_user.entries.build(entry_params)
		if @entry.save
			flash[:success] = "Entry created!"
			respond_to do |format|
				format.html { redirect_to root_url }
				format.js
			end
		else
			@feed_items = []
			render 'static_pages/home'
		end
	end

	def show
		@entry = Entry.find_by(id: params[:id])
		@comments = @entry.comments.paginate(page: params[:page], per_page: 5)
		if @entry.nil?
			flash[:danger] = "Entry not found"
			respond_to do |format|
				format.html { redirect_to request.referrer || root_url }
				format.js
			end
			
		end
	end

	def destroy
		@entry.destroy
		flash[:success] = "Entry deleted"
		if request.referrer == entry_path(@entry)
			@redirect = true
		end
		respond_to do |format|
			format.html { redirect_to root_url }
			format.js
		end
	end

	def edit
		@entry = Entry.find_by(id: params[:id])
		respond_to do |format|
			format.js
		end
	end

	def update
		@entry = Entry.find(params[:id])
		if @entry.update_attributes(entry_params)
			flash[:success] = "Entry updated"
			respond_to do |format|
				format.html { redirect_to @entry }
				format.js
			end
		else
			render 'edit'
		end
	end


	private
	def entry_params
		params.require(:entry).permit(:title, :content, :picture)
	end

	def correct_user
		@entry = current_user.entries.find_by(id: params[:id])
		redirect_to root_url if @entry.nil?
	end
end
